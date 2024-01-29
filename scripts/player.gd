extends CharacterBody2D

# SIGNALS 
signal leave

# CONSTANTS
var SPEED: float = 200.0
var DEADZONE: float = 0.2

# VARIABLES 
var player_id: int		# Contient l'id du joueur
var input			# "Input class" instance 
var cooldown = true
var rock_stocked = 0
var player_state_anim # Variable pour savoir quelle animation jouer

# TEXTURES
var rock = preload("res://scenes/pierre.tscn")


func init(player_num: int, device: int):
	player_id = player_num
	
	# in my project, I got the device integer by accessing the singleton autoload PlayerManager
	# but for simplicity, it's not an autoload in this demo.
	# but I recommend making it a singleton so you can access the player data from anywhere.
	# that would look like the following line, instead of the device function parameter above.
	# var device = PlayerManager.get_player_device(player_id)
	input = DeviceInput.new(device)
	
	$Player.text = "%s" % player_num



func _process(_delta):
	# let the player leave by pressing the "join" button
	if input.is_action_just_pressed("join-leave"):
		# an alternative to this is just call PlayerManager.leave(player_id)
		# but that only works if you set up the PlayerManager singleton
		leave.emit(player_id)

	# On stocke la direction du joueur dans un Vector2
	var direction: Vector2 = input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Conditions pour déterminer l'état du joueur pour l'animer
	if direction.x == 0 and direction.y == 0:
		player_state_anim = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state_anim = "moving"
	
	# On normalise la vitesse
	velocity = direction.normalized() * SPEED
	
	# On actualise la position + gestion des collisions
	move_and_slide()
	# On joue les différentes animations
	play_animation(direction)
	
	# Deplacement du marker2d
	var device = get_node("../PlayerManager").get_player_device(player_id)
	if device == -1:
		#var mouse_pos = get_global_mouse_position()
		#$Marker2D.look_at(mouse_pos)
		$Marker2D.global_position = get_global_mouse_position()
	
	elif device == 0 or device == 1:
		var joy_x = input.get_axis("look_left", "look_right")
		var joy_y = input.get_axis("look_up", "look_down")
		var joy_vec = Vector2(joy_x, joy_y)
		print(joy_vec)
		
		if joy_vec.length() > 0:
			#var joy_target = $Marker2D.global_position + joy_vec.normalized() * 500
			#$Marker2D.look_at(joy_target)
			$Marker2D.position = joy_vec.normalized() * 100
	
	
	# Gestion de l'evenement "lancer objet"
	if input.is_action_just_pressed("lancer_pierre") and cooldown and rock_stocked > 0:
		# Lancer de la pierre
		cooldown = false
		var rock_instance = rock.instantiate()
		rock_instance.rotation = $Marker2D.rotation
		rock_instance.global_position = $Marker2D.global_position
		add_child(rock_instance)
		rock_stocked -= 1
		# Ajout d'un compteur pour ne pas relancer instananement 
		await get_tree().create_timer(0.6).timeout
		cooldown = true
		
		
	if rock_stocked == 0:
		SPEED = 200.0

# Fonction pour animer le joueur
func play_animation(dir):
	if player_state_anim == "idle":
		$AnimatedSprite2D.play("idle")
	if player_state_anim == "moving":
		if dir.y == -1:
			$AnimatedSprite2D.play("walk_n")
		if dir.x == 1:
			$AnimatedSprite2D.play("walk_e")
		if dir.y == 1:
			$AnimatedSprite2D.play("walk_s")
		if dir.x == -1:
			$AnimatedSprite2D.play("walk_w")






# Ancien code aurelien 
	##On récupère les axes de déplacement de la manette
	#var movementVector = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0,JOY_AXIS_LEFT_Y))
	#
	##Si la magnitude du mouvement est plus grande que la deadzone -> on bouge, sinon à on reste à l'arrêt
	#if movementVector.length() > DEADZONE:
		#
		##Normalisation du vecteur (évite les mouvement plus rapides si on va en diagonale -> car sans ca on additionnerait la vitesse up et right par ex)
		#movementVector = movementVector.normalized()
		#
		##Déplacement du sprite
		#position += movementVector * speed * delta
		#print(movementVector)
	#else:
		#position += Vector2.ZERO

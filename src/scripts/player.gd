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
	
	$Id.text = "%s" % player_num


func _process(_delta):
	# On stocke la direction du joueur dans un Vector2
	var player_direction: Vector2 = input.get_vector("move_left", "move_right", "move_up", "move_down")
	# On normalise la vitesse
	velocity = player_direction.normalized() * SPEED
	# On actualise la position + gestion des collisions
	move_and_slide()
	
	# On joue les différentes animations
	play_animation(player_direction)
	
	# Actualiser la position du viseur
	actualiser_position_viseur()
	
	# Reactualiser vitesse joueur si la pierre n'est plus dans l'inventaire
	if rock_stocked == 0:
		SPEED = 200.0
	
	
	# ----- GESTION DES EVENEMENTS -----
	# let the player leave by pressing the "join" button
	if input.is_action_just_pressed("join-leave"):
		# an alternative to this is just call PlayerManager.leave(player_id)
		# but that only works if you set up the PlayerManager singleton
		leave.emit(player_id)

	# Gestion de l'evenement "lancer objet"
	if input.is_action_just_pressed("lancer_pierre") and cooldown and rock_stocked > 0:
		# Lancer de la pierre
		cooldown = false
		var rock_instance = rock.instantiate()
		# Calcul de la direction 
		var direction2 = $Viseur.global_position - position 
		direction2 = direction2.normalized()
		rock_instance.direction = direction2
		
		# rock_instance.rotation = angle
		rock_instance.global_position = position
		add_child(rock_instance)
		rock_stocked -= 1
		# Ajout d'un compteur pour ne pas relancer instananement 
		await get_tree().create_timer(0.6).timeout
		cooldown = true




# ------------ FONCTIONS ------------
func actualiser_position_viseur():
	var device = get_node("../PlayerManager").get_player_device(player_id)
	if device == -1:
		$Viseur.global_position = get_global_mouse_position()
	elif device == 0 or device == 1:
		var joy_x = input.get_axis("look_left", "look_right")
		var joy_y = input.get_axis("look_up", "look_down")
		var joy_vec = Vector2(joy_x, joy_y)
		$Viseur.position = joy_vec.normalized() * 100


# Fonction pour animer le joueur
func play_animation(dir):
	# Conditions pour déterminer l'état du joueur pour l'animer
	if dir.x == 0 and dir.y == 0:
		player_state_anim = "idle"
	elif dir.x != 0 or dir.y != 0:
		player_state_anim = "moving"
	
	# Animer joueur
	if player_state_anim == "idle":
		$AnimatedSprite2D.play("idle")
	if player_state_anim == "moving":
		if dir.x < 0:
			$AnimatedSprite2D.play("walk_w")
		elif dir.x > 0:
			$AnimatedSprite2D.play("walk_e")
		elif dir.y < 0:
			$AnimatedSprite2D.play("walk_n")
		elif dir.y > 0:
			$AnimatedSprite2D.play("walk_s")

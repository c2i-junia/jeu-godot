extends CharacterBody2D  

# SIGNALS 
signal leave

# CONSTANTS
var SPEED: float = 200.0
var DEADZONE: float = 0.2

# VARIABLES 
var player_id: int # Contient l'id du joueur
var input # "Input class" instance 
var cooldown = true
var rock_stocked = 0
var axe_stocked = 0
var player_state_anim # Variable pour savoir quelle animation jouer
var isFaster = false # Booléen pour savoir s'il faut rendre le joueur plus rapide
var isTransparent = false
var isEnraged = false
var delay_cooldown = 0 # Variable pour augmenter ou diminuer le cooldown du lancer d'objet
var timer = Timer.new()
var nom_pierre_lancee
var index = 0
var player_state = "alive"

# TEXTURES
var rock = preload("res://scenes/pierre.tscn")
var axe = preload("res://scenes/axe.tscn")
var collectableStone = preload("res://scenes/collectable_stone.tscn")

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
	if player_state == "alive":
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
	
	# ----- GESTION DES EFFETS DU JOUEUR -----
	# Rendre le joueur plus rapide
	if isFaster == true :
		change_speed()
	# Actualiser la vitesse du joueur si la pierre n'est plus dans l'inventaire
	if rock_stocked == 0 and isFaster == false:
		SPEED = 200.0
	# Gestion de la collision et de l'opacité du joueur
	if isTransparent == true:
		ghost_mode()
	# Augmenter la cadence de tir
	if isEnraged == true:
		rage_mode()
	
	# ----- GESTION DES EVENEMENTS -----
	# let the player leave by pressing the "join" button
	if input.is_action_just_pressed("join-leave"):
		# an alternative to this is just call PlayerManager.leave(player_id)
		# but that only works if you set up the PlayerManager singleton
		leave.emit(player_id)

	# Gestion de l'evenement "lancer objet"
	if input.is_action_just_pressed("lancer_pierre") and player_state == "alive" and cooldown and rock_stocked > 0:
		# Lancer de la pierre
		cooldown = false
		var rock_instance = rock.instantiate()
		# Calcul de la direction 
		var direction2 = $Viseur.global_position - position 
		direction2 = direction2.normalized()
		rock_instance.direction = direction2
		# rock_instance.rotation = angle
		rock_instance.global_position = position
		rock_instance.name = "Pierre" + str(index)
		index += 1 
		nom_pierre_lancee = rock_instance.name
		get_parent().add_child(rock_instance)
		rock_stocked -= 1
		# Ajout d'un compteur pour ne pas relancer instananement 
		await get_tree().create_timer(0.6 + delay_cooldown).timeout
		cooldown = true
		
	if input.is_action_just_pressed("lancer_pierre") and player_state == "alive" and cooldown and axe_stocked > 0:
		# Lancer de la hache
		cooldown = false
		var axe_instance = axe.instantiate()
		# Calcul de la direction 
		var direction2 = $Viseur.global_position - position 
		direction2 = direction2.normalized()
		axe_instance.direction = direction2
		axe_instance.global_position = position
		add_child(axe_instance)
		axe_stocked -= 1
		# Ajout d'un compteur pour ne pas relancer instananement 
		await get_tree().create_timer(0.6 + delay_cooldown).timeout
		cooldown = true



# ------------ FONCTIONS ------------
func actualiser_position_viseur():
	var device = get_node("../PlayerManager").get_player_device(player_id)
	if device == -1:
		$Viseur.global_position = get_global_mouse_position()
	elif device == 0 or device == 1:
		var joy_x = input.get_joy_axis(2) # Axe X du joystick gauche
		var joy_y = input.get_joy_axis(3) # Axe Y du joystick gauche
		var joy_vec = Vector2(joy_x, joy_y)
		$Viseur.position = joy_vec * 70
	if abs($Viseur.position) <= Vector2(5, 5): 
		$Viseur.visible = false
	else: 
		$Viseur.visible = true

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

func _on_area_2d_area_entered(area):
	if area.name != nom_pierre_lancee:
		if "Pierre" in area.name:
			var collectableStone_instance = collectableStone.instantiate()
			collectableStone_instance.global_position = position
			get_parent().call_deferred("add_child", collectableStone_instance)
			area.queue_free()
			player_state = "dead"
			$Viseur.visible = false
			$AnimatedSprite2D.play("death")

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		$AnimatedSprite2D.play("dead")

# ------------ EFFETS DES POTIONS ------------
# Fonctions des effets des items sur le joueur
func change_speed():
	SPEED = 500.0
	await get_tree().create_timer(3.0).timeout
	isFaster = false

func ghost_mode():
	get_node("CollisionShape2D").disabled = true
	$AnimatedSprite2D.self_modulate.a = 0.5
	await get_tree().create_timer(3.0).timeout
	get_node("CollisionShape2D").disabled = false
	$AnimatedSprite2D.self_modulate.a = 1
	isTransparent = false

func rage_mode():
	delay_cooldown = -0.5
	await get_tree().create_timer(6.0).timeout
	isEnraged = false
	delay_cooldown = 0

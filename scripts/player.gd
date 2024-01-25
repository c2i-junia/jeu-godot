extends CharacterBody2D


var SPEED = 200.0
var DEADZONE = 0.2

var rock_equiped = false
var cooldown = true
var rock = preload("res://scenes/pierre.tscn")

func _physics_process(delta):
	# On stocke la direction du joueur dans un Vector2
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# On normasoulise la vitesse
	velocity = direction.normalized() * SPEED
	
	# On actualise la position + gestions des collisions
	move_and_slide()
	
	if Input.is_action_just_pressed("e"):
		if rock_equiped:
			rock_equiped = false
			SPEED = 400.0
		else:
			rock_equiped = true
			SPEED = 100.0 

	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("left_mouse") and cooldown and rock_equiped:
		cooldown = false
		var rock_instance = rock.instantiate()
		rock_instance.rotation = $Marker2D.rotation
		rock_instance.global_position = $Marker2D.global_position
		add_child(rock_instance)
		
		await get_tree().create_timer(0.6).timeout
		cooldown = true
		
		
	######################################################################
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

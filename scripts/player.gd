extends CharacterBody2D


const SPEED = 200.0
var DEADZONE = 0.2


func _physics_process(delta):
	# On stocke la direction du joueur dans un Vector2
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# On normalise la vitesse
	velocity = direction.normalized() * SPEED
	
	# On actualise la position + gestions des collisions
	move_and_slide()
	
	
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

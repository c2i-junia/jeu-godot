extends Node2D

#Valeur arbitraire de la vitesse
var speed = 150
var deadzone =0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	#On récupère les axes de déplacement de la manette
	var movementVector = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0,JOY_AXIS_LEFT_Y))
	
	#Si la magnitude du mouvement est plus grande que la deadzone -> on bouge, sinon à on reste à l'arrêt
	if movementVector.length() > deadzone:
		
		#Normalisation du vecteur (évite les mouvement plus rapides si on va en diagonale -> car sans ca on additionnerait la vitesse up et right par ex)
		movementVector = movementVector.normalized()
		
		#Déplacement du sprite
		position += movementVector * speed * delta
		print(movementVector)
	else:
		position += Vector2.ZERO

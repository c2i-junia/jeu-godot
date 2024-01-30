extends Area2D

var speed = 400 # Vitesse de la fleche 
var direction

func _ready():
	set_as_top_level(true) # La flèche sera vu par dessus nimporte quel objet
	
func _process(delta):
	#position += (Vector2.RIGHT * speed).rotated(rotation) * delta
	position += direction * speed * delta
	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.name == "bordDeMap" or body.name == "Rock":
		queue_free()

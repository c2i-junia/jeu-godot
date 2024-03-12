extends Area2D

var speed = 450
var maxDistance = 250
var travelledDistance = 0
var direction
var direction_player
var isReturning = false
var thrower_name
var thrower_node

func _ready():
	set_as_top_level(true) # La hache sera vue par dessus n'importe quel objet
	
func _process(delta):
	if isReturning == false:
		position += direction * speed * delta
		travelledDistance += speed * delta
		if travelledDistance >= maxDistance:
			isReturning = true
	else:
		#var player = get_parent().get_node("Player")
		direction_player = (thrower_node.position - position).normalized()
		translate(direction_player * speed * delta)
		if position.distance_to(thrower_node.position) < 5.0:
			isReturning = false
			queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

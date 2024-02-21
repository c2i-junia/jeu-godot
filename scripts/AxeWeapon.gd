extends Area2D

var speed = 450 # Vitesse de la fleche
var maxDistance = 250
var travelledDistance = 0
var direction
var isReturning = false

func _ready():
	set_as_top_level(true) # La hache sera vue par dessus nimporte quel objet
	var originalPositionAxe = position
	
func _process(delta):
	if isReturning == false:
		position += direction * speed * delta
		travelledDistance += speed * delta
		if travelledDistance >= maxDistance:
			isReturning = true
	else:
		var player = get_parent().get_node("Player")
		var direction_player =  (player.position - position).normalized()
		translate(direction_player * speed * delta)
		if position.distance_to(player.position) < 5.0:
			isReturning = false
			queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

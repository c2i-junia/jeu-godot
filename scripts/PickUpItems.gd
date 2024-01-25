extends Area2D

@onready var player = $"../Player"

var isInRange = false

func _physics_process(delta):
	if isInRange == true and Input.is_action_just_pressed("f"):
		player.rock_equiped = true
		isInRange = false
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		isInRange = true

func _on_body_exited(body):
	if body.name == "Player":
		isInRange = false

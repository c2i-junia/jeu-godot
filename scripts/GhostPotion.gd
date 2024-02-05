extends Area2D

var player_instance
var isInRange = false

func _physics_process(_delta):
	if isInRange == true and player_instance.input.is_action_just_pressed("ramasser_pierre") and player_instance.rock_stocked == 0:
		player_instance.isTransparent = true
		isInRange = false
		queue_free()

func _on_body_entered(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		player_instance = body
		isInRange = true

func _on_body_exited(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		isInRange = false

extends Area2D

var player_instance
var isInRange = false

func _physics_process(_delta):
	if isInRange == true and player_instance.input.is_action_just_pressed("ramasser_pierre"):
		if player_instance.weapon_stocked["type"] == "null":
			player_instance.weapon_stocked["type"] = "rock"
			player_instance.weapon_stocked["count"] = 1
		
		elif player_instance.weapon_stocked["type"] == "rock":
			player_instance.weapon_stocked["count"] += 1
		
		player_instance.SPEED = 150.0
		isInRange = false
		queue_free()

func _on_body_entered(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		player_instance = body
		isInRange = true

func _on_body_exited(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		isInRange = false

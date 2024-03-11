extends Area2D

var player_instance
var player_main_node
var isInRange = false

func _physics_process(_delta):
	if isInRange == true and player_instance.input.is_action_just_pressed("ramasser_pierre"):
		player_main_node.change_skin()

func _on_body_entered(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		player_instance = body
		player_main_node = get_path_to(body)
		player_main_node = get_node(player_main_node)
		isInRange = true

func _on_body_exited(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		isInRange = false

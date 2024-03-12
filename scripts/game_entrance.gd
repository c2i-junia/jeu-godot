extends Area2D

var player_instance
var player_main_node
var players_ready = {}
var world_node = preload("res://scenes/world.tscn").instantiate()
var isChangingFile = false

func _ready():
	$"../RichTextLabel".visible = false

func _physics_process(_delta):
	if get_parent().player_nodes == players_ready and players_ready != {}:
		$"../RichTextLabel".visible = true
		if player_instance.input.is_action_just_pressed("ramasser_pierre"):
			isChangingFile = true
			for i in players_ready:
				players_ready[i].get_parent().remove_child(players_ready[i])
				world_node.add_child(players_ready[i])
			get_tree().root.add_child(world_node)
			get_tree().root.remove_child(get_parent())
	else:
		$"../RichTextLabel".visible = false

func _on_body_entered(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		player_instance = body
		player_main_node = get_path_to(body)
		player_main_node = get_node(player_main_node)
		players_ready[player_main_node.player_id] = player_main_node

func _on_body_exited(body):
	if is_instance_valid(body) and body is CharacterBody2D and isChangingFile == false:
		players_ready.erase(body.player_id)

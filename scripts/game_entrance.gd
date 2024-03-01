extends Area2D

var player_instance
var player_main_node
var players_ready = {}

func _ready():
	$"../RichTextLabel".visible = false

func _physics_process(_delta):
	if get_parent().player_nodes == players_ready and players_ready != {}:
		$"../RichTextLabel".visible = true
		if player_instance.input.is_action_just_pressed("ramasser_pierre"):
			get_tree().change_scene_to_file("res://scenes/world.tscn")
	else:
		$"../RichTextLabel".visible = false

func _on_body_entered(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		player_instance = body
		player_main_node = get_path_to(body)
		player_main_node = get_node(player_main_node)
		players_ready[player_main_node.player_id] = player_main_node
		#print(get_parent())
		#print(player_ready[player_main_node.player_id])
		#print(player_ready)
		#print(get_parent().player_nodes)

func _on_body_exited(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		players_ready.erase(body.player_id)

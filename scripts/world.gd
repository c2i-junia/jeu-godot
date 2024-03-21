extends Node2D

# map from player integer to the player node
var player_nodes = {}
var spawn_positions: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerManager.player_joined.connect(spawn_player)
	$PlayerManager.player_left.connect(delete_player)
	spawn_positions = [$Spawn1.position, $Spawn2.position, $Spawn3.position, $Spawn4.position]
	if Global.players_in_game != {}:
		for i in Global.players_in_game:
			Global.players_in_game[i].position = spawn_positions[i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$PlayerManager.handle_join_input()
	if Global.worlds_data["number_player"] == 1 and Global.worlds_data["game_state"] == "in_game":
		print("On a un vainqueur !")
		Global.worlds_data["game_state"] = "changing_map"

func spawn_player(player_id: int):
	# create the player node
	var player_scene = load("res://scenes/player.tscn")
	var player_node = player_scene.instantiate()
	player_node.leave.connect(on_player_leave)
	player_nodes[player_id] = player_node
	# let the player know which device controls it
	var device = $PlayerManager.get_player_device(player_id)
	player_node.init(player_id, device)
	# add the player to the tree
	add_child(player_node)
	player_node.name = "Player" + str(player_id)
	# random spawn position
	player_node.position = spawn_positions[player_id]
	Global.players_in_game[player_id] = player_node
	Global.worlds_data["number_player"] += 1

func delete_player(player_id: int):
	player_nodes[player_id].queue_free()
	player_nodes.erase(player_id)

func on_player_leave(player_id: int):
	# just let the player manager know this player is leaving
	# this will, through the player manager's "player_left" signal,
	# indirectly call delete_player because it's connected in this file's _ready()
	$PlayerManager.leave(player_id)

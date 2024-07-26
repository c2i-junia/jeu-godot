extends Area2D

var player_instance
var player_main_node
var isInRange = false
var IdSkinSprite = 0
var device

func _ready():
	$Label.visible = false
	$Control.visible = false

func _physics_process(_delta):
	match IdSkinSprite:
		0:
			$Control/SelectSkinSprite.play("knight_idle")
		1:
			$Control/SelectSkinSprite.play("dwarf_idle")
	if isInRange == true and player_instance.input.is_action_just_pressed("ramasser_pierre"):
		player_main_node.player_state = "choosing"
		$Control.visible = true
		$Label.visible = false

func _on_body_entered(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		player_instance = body
		player_main_node = get_node(get_path_to(body))
		isInRange = true
		$Label.visible = true
		device = get_node("../PlayerManager").get_player_device(player_main_node.player_id)

func _on_body_exited(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		isInRange = false
		$Label.visible = false

func _on_right_button_pressed():
	if device == -1:
		if IdSkinSprite < 1:
			IdSkinSprite += 1
		elif IdSkinSprite == 1:
			IdSkinSprite = 0

func _on_left_button_pressed():
	if device == -1:
		if IdSkinSprite > 0:
			IdSkinSprite -= 1
		elif IdSkinSprite == 0:
			IdSkinSprite = 1

func _on_select_button_pressed():
	player_main_node.change_skin(IdSkinSprite)
	$Control.visible = false
	$Label.visible = true

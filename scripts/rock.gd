extends StaticBody2D

var player_instance
var isInRange = false
var nb_players_in_range = 0

func _ready():
	$Label.visible = false

func _physics_process(_delta):
	if isInRange == true and player_instance.input.is_action_just_pressed("ramasser_pierre") and player_instance.rock_stocked < 3:
		player_instance.rock_stocked += 1
		$RockCollectSound.play()
	if nb_players_in_range != 0:
		$Label.visible = true
	else:
		$Label.visible = false

func _on_area_2d_body_entered(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		player_instance = body
		nb_players_in_range += 1
		isInRange = true

func _on_area_2d_body_exited(body):
	if is_instance_valid(body) and body is CharacterBody2D:
		isInRange = false
		nb_players_in_range -= 1

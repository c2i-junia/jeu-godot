extends TextureProgressBar

var can_regen = false
var wait_time = 1
var timer = 0
var start_timer = true

func _ready():
	value = max_value

func _process(delta):
	if can_regen == false && value != 100:
		start_timer = true
		if start_timer == true:
			timer += delta
			if timer >= wait_time:
				can_regen = true
				start_timer = false
				timer = 0
	
	if value == 100:
		can_regen = false
	
	if can_regen == true:
		value += 0.5
		start_timer = false
		timer = 0

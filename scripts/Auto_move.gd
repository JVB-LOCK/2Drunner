extends Camera2D

@export var follow_speed: float = 50.0     
@export var deadzone: float = 25.0      
@export var auto_scroll_speed: float = 300

var player: Node2D

func _ready():
	player = get_node("/root/Level 1/Player")  

func _process(delta):
	if player:
		# Auto-scroll if player is too far left
		if player.global_position.x < global_position.x - deadzone:
			position.x += auto_scroll_speed * delta
		# Else, follow player smoothly
		else:
			position.x = lerp(position.x, player.global_position.x, follow_speed * delta)

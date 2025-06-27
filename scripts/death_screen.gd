extends CanvasLayer

@onready var countdown_label = $ColorRect/Label
@onready var timer = $Timer
@onready var menu_button = $ColorRect/Menu

var countdown_time = 5  # seconds

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	start_countdown()

func start_countdown():
	countdown_label.text = "Respawning in: %d" % countdown_time
	timer.start(1.0)  # 1 second intervals

func _on_timer_timeout():
	countdown_time -= 1
	countdown_label.text = "Respawning in: %d" % countdown_time
	
	if countdown_time <= 0:
		timer.stop()
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

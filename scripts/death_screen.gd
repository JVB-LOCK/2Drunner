extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label
@onready var menu_button: Button = $ColorRect/Menu
@onready var timer: Timer = $Timer
func _ready() -> void:
	hide()
func show_death_screen(respawn_time: float = 5.0) -> void:
	label.text = "Respawning in: %.1f" % respawn_time
	timer.start(1.0)  

func hide_death_screen() -> void:
	hide()
	timer.stop()

func _on_timer_timeout() -> void:
	var time_left = timer.time_left
	label.text = "Respawning in: %.1f" % time_left
	
	if time_left <= 0:
		get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

extends Button

var pause_menu_instance: Control = null  
var pause_canvas_layer: CanvasLayer = null
@onready var back_pause: Button = $"../Back_Pause"
@onready var resume: Button = $"."

func _on_pressed() -> void:
	pause_canvas_layer = null
	back_pause.visible = false
	resume.visible = false
	# Unpause the game
	get_tree().paused = false
	# Remove the pause men
	get_tree().reload_current_scene()

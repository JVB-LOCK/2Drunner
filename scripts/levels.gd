extends CanvasLayer

@onready var level_2: Button = $ColorRect/Level_2

func _ready() -> void:
	level_2.disabled = true
#func _on_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/level_2.tscn")

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_basics_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/how_to_play.tscn")

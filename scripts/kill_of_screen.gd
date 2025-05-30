extends Area2D

@onready var timer: Timer = $Timer



func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()

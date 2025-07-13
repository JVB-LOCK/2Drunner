extends Button

func _on_pressed() -> void:
	# Unpause the game
	get_tree().paused = false
	# Remove the pause men
	get_parent().queue_free()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

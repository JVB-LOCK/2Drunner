extends Button


func _on_pressed() -> void:
	# Unpause the game
	get_tree().paused = false
	# Remove the pause men
	get_parent().queue_free()

extends Node

var pause_menu_scene = preload("res://scenes/pause_menu.tscn")
var pause_menu_instance: Control = null  
var pause_canvas_layer: CanvasLayer = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			# Unpause and cleanup
			get_tree().paused = false
			if pause_canvas_layer:
				pause_canvas_layer.queue_free()
				pause_canvas_layer = null
		else:
			# Pause and create menu
			get_tree().paused = true
			
			# 1. Create CanvasLayer
			pause_canvas_layer = CanvasLayer.new()
			
			# 2. Create menu - THIS IS WHERE THE ERROR WAS HAPPENING
			# Ensure your scene's root node is actually a Control-derived type
			pause_menu_instance = pause_menu_scene.instantiate() as Control  # Explicit cast
			if !pause_menu_instance:
				push_error("Pause menu scene root is not a Control node!")
				return
				
			pause_menu_instance.process_mode = Node.PROCESS_MODE_ALWAYS
			pause_canvas_layer.add_child(pause_menu_instance)
			
			# 3. Add to scene tree
			get_tree().root.add_child(pause_canvas_layer)

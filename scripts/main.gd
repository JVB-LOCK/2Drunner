extends Node

func _ready():
	# Connect the resize signal
	get_viewport().connect("size_changed", Callable(self, "_on_viewport_resized"))
	# Call it once to initialize
	_on_viewport_resized()

func _on_viewport_resized():
	var viewport = get_viewport()
	var window_size = viewport.size
	
	# Adjust camera if you have one
	if has_node("/root/Main/Camera2D"):
		var camera = get_node("/root/Main/Camera2D")
		var base_res = Vector2(1920, 1080)  # Your base resolution
		var scale_factor = max(window_size.x / base_res.x, window_size.y / base_res.y)
		camera.zoom = Vector2.ONE * scale_factor
	
	# Scale UI elements (if using CanvasLayer)
	for child in get_tree().get_nodes_in_group("ui_elements"):
		child.scale = Vector2.ONE * min(
			window_size.x / 1920.0,
			window_size.y / 1080.0
		)

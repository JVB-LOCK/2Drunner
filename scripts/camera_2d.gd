extends Camera2D

const SPEED = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Makes camra moves left 
func _process(delta: float) -> void:
	position.x += SPEED
	pass
	

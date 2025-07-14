extends Camera2D

const SPEED = 4

# Makes camra moves right
func _process(_delta: float) -> void:
	position.x += SPEED
	pass
	

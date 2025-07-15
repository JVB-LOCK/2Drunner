extends Camera2D

var SPEED = 4

# Makes camra moves right
func _physics_process(_delta: float) -> void:
	position.x += SPEED
	SPEED = 0

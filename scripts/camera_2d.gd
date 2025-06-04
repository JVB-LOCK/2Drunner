extends Camera2D

const SPEED = 4


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Makes camra moves left 
func _process(_delta: float) -> void:
	position.x += SPEED
	pass
	

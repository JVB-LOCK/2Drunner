extends Area2D

signal unlockedphase

func _ready():
	body_entered.connect(test)
	
	
func test(_body):
	print("Picked Up")
	emit_signal("unlockedphase", test)
	queue_free()

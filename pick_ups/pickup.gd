extends Area2D

signal unlockedphase

func _ready():
	body_entered.connect(test)

	
func test(body):
	print("fwa")
	queue_free()

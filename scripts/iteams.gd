extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Pickup_Phase.unlockedphase.connect(test)
	
func test(_body):
	Global.phased_unlocked = true
	print("Nice")
	

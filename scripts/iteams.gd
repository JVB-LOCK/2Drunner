extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Pickup_Phase.unlockedphase.connect(phase)
	
func phase(_body):
	print("Unlocked Phased")
	Global.phased_unlocked = true

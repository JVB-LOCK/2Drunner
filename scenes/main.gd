extends Node2D

@onready var pickup_phase: Area2D = $Pickup_Phase


func _ready() -> void:
	$Pickup_Phase.connect("unlockedphase", test)
	
func test() -> void:
	print("Nice")
	

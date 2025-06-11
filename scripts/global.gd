extends Node

var phased_unlocked = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.phased_unlocked = false
	print("Yes")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

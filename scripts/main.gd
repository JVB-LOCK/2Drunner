extends Node2D

func _ready() -> void:
	##Restes phase when sence is rest
	print("Reset")
	Global.phased_unlocked = false

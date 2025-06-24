extends Control

const FIRSTUPGRADE = preload("res://scenes/First_upgrade.tscn")


func _on_timer_timeout() -> void:
	var spawn = FIRSTUPGRADE.instantiate()
	add_child(spawn)

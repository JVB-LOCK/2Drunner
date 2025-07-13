extends Control

const FIRSTUPGRADE = preload("res://scenes/First_upgrade.tscn")



func _on_timer_timeout() -> void:
	if Global.phase_bought == false and Global.phased_unlocked == true:
		var spawn = FIRSTUPGRADE.instantiate()
		add_child(spawn)
		Global.phase_bought = true
	else:
		pass

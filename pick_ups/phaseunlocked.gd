extends Area2D

signal unlockedphase

func _ready():
	
	# Check if already collected and hide if true
	if Global.phased_picked_up == true:
		queue_free()  
	else:
		visible = true
func _on_body_entered(_body):
	if not Global.phased_unlocked:
		print("Phase Ability Picked Up")
		Global.phased_picked_up = true
		Global.phased_unlocked = true
	queue_free()

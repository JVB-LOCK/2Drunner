extends Node2D

func _ready() -> void:
	# Wait until next frame to ensure all nodes are loaded
	call_deferred("_connect_pickup_signal")

func _connect_pickup_signal():
	if has_node("Pickup_Phase"):
		var pickup = get_node("Pickup_Phase")
		if not pickup.unlockedphase.is_connected(phase):
			pickup.unlockedphase.connect(phase)
	else:
		# Only show error if phase ability isn't already unlocked
		if not Global.phased_unlocked:
			printerr("Pickup_Phase node not found and phase not unlocked!")

func phase(_body):
	print("Unlocked Phased")
	Global.phased_unlocked = true

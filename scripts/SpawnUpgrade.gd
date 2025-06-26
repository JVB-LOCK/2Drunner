extends Control


func _on_buy_pressed() -> void:
	Global.phase_bought = true
	print("Bought phase")
	queue_free()

extends Area2D

signal unlockedphase

func _ready():
	body_entered.connect(phase)
	
	
func phase(_body):
	print("Picked Up")
	emit_signal("unlockedphase", phase)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

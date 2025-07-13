extends Area2D

signal unlockedphase(body)  

func _ready():
	if Global.phased_picked_up:
		queue_free()

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D and not Global.phased_unlocked:  
		Global.phased_picked_up = true
		Global.phased_unlocked = true
		emit_signal("unlockedphase", body) 
		queue_free()

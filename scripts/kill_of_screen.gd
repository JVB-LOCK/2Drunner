extends Area2D

@onready var timer: Timer = $Timer
@export var death_screen_scene: PackedScene

#Kills player if they are off camra 
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	await get_tree().create_timer(0.80).timeout 
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
	

extends Area2D

@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
		print("You win!")
		get_tree().change_scene_to_file("res://path_to_your_main_menu.tscn") 

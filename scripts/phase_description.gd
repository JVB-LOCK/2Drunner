extends Label

const PHASE_DESCRIPTION = preload("res://Tres/Phase_Description.tres")

@onready var description: Label = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	description.text= PHASE_DESCRIPTION.description

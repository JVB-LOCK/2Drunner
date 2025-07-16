extends Area2D

signal unlockedphase(body)

# UI References
@onready var unlock_message: Label = %Unlock_message
@onready var resume_button: Button = %Resume_button

func _ready():
	if Global.phased_picked_up:
		queue_free()
	
	# Initialize hidden
	unlock_message.visible = false
	resume_button.visible = false

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D and not Global.phased_unlocked:
		Global.phased_picked_up = true
		Global.phased_unlocked = true
		emit_signal("unlockedphase", body)
		
		# Get viewport center as Vector2 (float)
		var viewport_size = Vector2(get_viewport().size)
		var center = viewport_size / 2.0
		
		# Position button at center (convert sizes to Vector2)
		resume_button.position = center - (Vector2(resume_button.size) / 2.0)
		resume_button.visible = true
		resume_button.process_mode = Node.PROCESS_MODE_ALWAYS
		
		# Position label above button (with 20px gap)
		unlock_message.position = Vector2(
			center.x - (unlock_message.size.x / 2.0),  # Same horizontal center
			(resume_button.position.y - unlock_message.size.y) - 20.0  # Above button
		)
		unlock_message.text = "Phase Ability Unlocked!"
		unlock_message.visible = true
		
		get_tree().paused = true

func _on_resume_pressed():
	get_tree().paused = false
	unlock_message.visible = false
	resume_button.visible = false
	queue_free()

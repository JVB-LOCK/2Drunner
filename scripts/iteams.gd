extends Node2D

# Reference to your UI elements (set these in the editor or via % paths)
@onready var unlock_message: Label = %Unlock_message  # Or direct path
@onready var resume_button: Button = %Resume_button

func _ready() -> void:
	# Hide UI elements initially
	if unlock_message:
		unlock_message.visible = false
	if resume_button:
		resume_button.visible = false
	
	# Wait until next frame to ensure all nodes are loaded
	call_deferred("_connect_pickup_signal")

func phase(_body):
	print("Unlocked Phased")
	Global.phased_unlocked = true
	
	# Show UI elements exactly where placed in editor
	if unlock_message:
		unlock_message.text = "Phase Ability Unlocked!"
		unlock_message.visible = true
		
	if resume_button:
		resume_button.visible = true
		resume_button.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Pause game
	get_tree().paused = true

func _on_resume_pressed():
	# Unpause game
	get_tree().paused = false
	
	# Hide UI
	if unlock_message:
		unlock_message.visible = false
	if resume_button:
		resume_button.visible = false

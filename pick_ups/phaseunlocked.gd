extends Area2D

signal unlockedphase(body)

# UI References 
@onready var unlock_message: Label = %Unlock_message
@onready var resume_button: Button = %Resume_button

func _ready():
	# Debug node references
	print("Button path: ", resume_button.get_path() if resume_button else "MISSING")
	print("Label path: ", unlock_message.get_path() if unlock_message else "MISSING")
	
	if Global.phased_picked_up:
		queue_free()
	
	# Safely initialize UI state
	if resume_button:
		resume_button.visible = false
	else:
		printerr("Resume button not found! Check path.")
	
	if unlock_message:
		unlock_message.visible = false
	else:
		printerr("Unlock label not found! Check path.")
	
	# Connect button
	if resume_button:
		if resume_button.pressed.is_connected(_on_resume_pressed):
			resume_button.pressed.disconnect(_on_resume_pressed)
		resume_button.pressed.connect(_on_resume_pressed)

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D and not Global.phased_unlocked:  
		Global.phased_picked_up = true
		Global.phased_unlocked = true
		emit_signal("unlockedphase", body)
		
		# Safely show UI
		if unlock_message:
			unlock_message.text = "Phase Ability Unlocked!"
			unlock_message.visible = true
		if resume_button:
			resume_button.visible = true
		
		get_tree().paused = true
		hide()

func _on_resume_pressed():
	# Safely hide UI
	if unlock_message:
		unlock_message.visible = false
	if resume_button:
		resume_button.visible = false
	
	get_tree().paused = false
	queue_free()

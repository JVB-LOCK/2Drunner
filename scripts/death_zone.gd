extends Area2D

#signal unlockedphase(body)

# UI References 
@onready var unlock_message: Label = %Unlock_message
@onready var resume_button: Button = %Resume_button

func _ready():
	if Global.phased_picked_up:
		queue_free()
	
	if resume_button:
		resume_button.visible = false
		
	if unlock_message:
		unlock_message.text = "Phase Ability Unlocked!"
		unlock_message.visible = true
		unlock_message.position.y -= 70000
		
func _on_body_entered(body: Node2D):
	if body is CharacterBody2D and not Global.phased_unlocked:  
		Global.phased_picked_up = true
		Global.phased_unlocked = true
		emit_signal("unlockedphase", body)
		
		# Get viewport center in screen coordinates
		var viewport = get_viewport()
		var screen_center = viewport.size / 2
		
		# Position UI elements
		if unlock_message:
			unlock_message.text = "Phase Ability Unlocked!"
			unlock_message.visible = true
			unlock_message.position = screen_center - (unlock_message.size / 2)
		if resume_button:
			resume_button.visible = true
			resume_button.position = screen_center - (resume_button.size / 2)
			resume_button.process_mode = Node.PROCESS_MODE_ALWAYS
		
		get_tree().paused = true

func _on_resume_pressed():
	get_tree().paused = false
	
	if resume_button:
		resume_button.visible = false
	
	if unlock_message:
		unlock_message.visible = false
	
	queue_free()

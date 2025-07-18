extends Area2D

signal unlockedphase(body)

# UI References
@onready var unlock_message: Label = %Unlock_message
@onready var resume_button: Button = %Resume_button
@onready var main_menu: Button = %Main_Menu


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
		
		# Get viewport center as Vector2
		var viewport_size = Vector2(get_viewport().size)
		var center = viewport_size / 2.0
		
		# Position button at center (
		resume_button.position = center - (Vector2(resume_button.size) / 2.0)
		resume_button.visible = true
		resume_button.process_mode = Node.PROCESS_MODE_ALWAYS
		
		# Position button at center (
		main_menu.position = Vector2(
			center.x - (main_menu.size.x / 2.0),  # Same horizontal center
			(main_menu.position.y - resume_button.size.y) + 110.0
		)
		
		main_menu.visible = true
		main_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		
		# Position label above button 
		unlock_message.position = Vector2(
			center.x - (unlock_message.size.x / 2.0),  # Same horizontal center
			(resume_button.position.y - unlock_message.size.y) - 100.0  # Above button
		)
		unlock_message.text = "Phase Ability Unlocked! 
	Go to the main menu screen and click upgrade to see the upgrades you can buy"
		unlock_message.visible = true

		get_tree().paused = true

func _on_resume_pressed():
	get_tree().paused = false
	unlock_message.visible = false
	resume_button.visible = false
	main_menu.visible = false
	queue_free()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	unlock_message.visible = false
	resume_button.visible = false
	main_menu.visible = false
	queue_free()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

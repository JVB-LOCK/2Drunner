extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var timer: Timer = $Timer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
#Makes you phase
	if Input.is_action_just_pressed("phase"):
		get_node("CollisionShape2D").disabled = true
		timer.start()
#Pressing the unphase button makes you unphase
	if Input.is_action_just_pressed("unphase"):
		get_node("CollisionShape2D").disabled = false
		
#When timer runs out unphase
func _on_timer_timeout() -> void:
	get_node("CollisionShape2D").disabled = false

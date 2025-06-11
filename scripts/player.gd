extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_phased = false
var phase_timeout = false

@onready var timer: Timer = $Phaseout


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
	if Input.is_action_just_pressed("phase") and is_phased == false and Global.phased_unlocked == true and phase_timeout == false:
		is_phased = true
		phase_timeout = true
		get_node("CollisionShape2D").disabled = true
		print("Start Phase")
		$PhaseTimeout.start()
		$Phaseout.start()
	elif Input.is_action_just_pressed("phase") and Global.phased_unlocked == true:
		get_node("CollisionShape2D").disabled = false
		print("Manle stopped")
		
#When timer runs out unphase
func _on_timer_timeout() -> void:
		get_node("CollisionShape2D").disabled = false
		is_phased = false
		print("Auto timed out")
			

func _on_can_phase_timeout() -> void:
	phase_timeout = false

extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 4000.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 1

var is_phased = false
var phase_timeout = false
var can_dash = true
var is_dashing = false
var jump_count = 0
var max_jumps = 2  # Allows for double jump

@onready var timer: Timer = $Phaseout
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var dash_timer: Timer = Timer.new()
@onready var dash_cooldown_timer: Timer = Timer.new()

func _ready() -> void:
	add_child(dash_timer)
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_end_dash)
	
	# Setup dash cooldown timer
	add_child(dash_cooldown_timer)
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(_enable_dash)
	
	# Skip movement if dashing
	if is_dashing:
		move_and_slide()
	return
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	#Handle jump (with double jump)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count += 1
		elif jump_count < max_jumps - 1:  # Allows  additional jump
			velocity.y = JUMP_VELOCITY * 0.9  # Slightly weaker double jump
			jump_count += 1
			
# Reset jump count when on floor
	if is_on_floor():
		jump_count = 0
	
	# Handle jump normaly.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# Get input direction
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
# Handle dash
	if Input.is_action_just_pressed("dash") and can_dash:
		_start_dash(direction) 
		var dash_direction = direction if direction != 0 else sign(velocity.x) if velocity.x != 0 else 1
		velocity = Vector2(dash_direction * DASH_SPEED, 0)
		
		dash_timer.start(DASH_DURATION)
		dash_cooldown_timer.start(DASH_COOLDOWN)
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

func _start_dash(direction):
	can_dash = false
	is_dashing = true
	collision_shape.disabled = true  # Phase through walls
	
func _enable_dash():
	can_dash = true
	
func _end_dash():
	is_dashing = false
	collision_shape.disabled = false  # Re-enable collisions
	velocity.x = move_toward(velocity.x, 100, SPEED)  # Smooth stop

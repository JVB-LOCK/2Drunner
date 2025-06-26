extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 1000.0 
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 1.0

var is_phased = false
var phase_timeout = false
var can_dash = true
var is_dashing = false
var jump_count = 0
var max_jumps = 1  # Allows for double jump


@onready var timer: Timer = $Phaseout
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var dash_timer: Timer = Timer.new()
@onready var dash_cooldown_timer: Timer = Timer.new()

func _ready() -> void:
	# Dash timer setup
	add_child(dash_timer)
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_end_dash)
	
	# Dash cooldown timer setup
	add_child(dash_cooldown_timer)
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(_enable_dash)

func _physics_process(delta: float) -> void:
	# Handle gravity
	if not is_on_floor() and not is_dashing:  # No gravity during dash
		velocity.y += get_gravity().y * delta
	
	# Handle jump (with double jump)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count = 1
		elif jump_count < max_jumps:
			velocity.y = JUMP_VELOCITY * 0.9  # Slightly weaker double jump
			jump_count += 1
	
	# Reset jump count when on floor
	if is_on_floor():
		jump_count = 0
	
	# Get input direction
	var direction := Input.get_axis("left", "right")
	
	# Handle movement - only if not dashing
	if not is_dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle dash
	if Input.is_action_just_pressed("dash") and can_dash:
		_start_dash(direction)
	
	# Handle phase ability
	if Input.is_action_just_pressed("phase") and not is_phased and Global.phase_bought and not phase_timeout:
		is_phased = true
		phase_timeout = true
		collision_shape.disabled = true
		print("Start Phase")
		$PhaseTimeout.start()
		$Phaseout.start()
	elif Input.is_action_just_pressed("phase") and Global.phased_unlocked:
		collision_shape.disabled = false
		is_phased = false
		print("Manual stop")
	
	move_and_slide()

func _on_timer_timeout() -> void:
	collision_shape.disabled = false
	is_phased = false
	print("Auto timed out")

func _on_can_phase_timeout() -> void:
	phase_timeout = false

func _start_dash(direction: float):
	can_dash = false
	is_dashing = true
	
	# Determine dash direction
	var dash_direction = direction if direction != 0 else sign(velocity.x) if velocity.x != 0 else 1
	
	# Apply dash velocity only horizontal for now
	velocity = Vector2(dash_direction * DASH_SPEED, 0)
	
	# Start timers
	dash_timer.start(DASH_DURATION)
	dash_cooldown_timer.start(DASH_COOLDOWN)
	
	# Disable collisions during dash only if phased ability is unlocked
	collision_shape.disabled = Global.phase_bought

func _enable_dash():
	can_dash = true

func _end_dash():
	is_dashing = false
	collision_shape.disabled = false
	

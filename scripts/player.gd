extends CharacterBody2D

# Movement constants
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 1000.0 
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 1.0

# State variables
var is_phased = false
var phase_timeout = false
var can_dash = true
var is_dashing = false
var jump_count = 0
var max_jumps = 1
var is_dead = false
var respawn_position: Vector2

# Nodes
@onready var timer: Timer = $Phaseout
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var dash_timer: Timer = Timer.new()
@onready var dash_cooldown_timer: Timer = Timer.new()

func _ready() -> void:
	# Timer setups
	add_child(dash_timer)
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_end_dash)
	
	add_child(dash_cooldown_timer)
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(_enable_dash)
	
func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# Gravity
	if not is_on_floor() and not is_dashing:
		velocity.y += get_gravity().y * delta
	
	# Jumping
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count = 1
		elif jump_count < max_jumps:
			velocity.y = JUMP_VELOCITY * 0.9
			jump_count += 1
	
	if is_on_floor():
		jump_count = 0
	
	# Movement
	var direction := Input.get_axis("left", "right")
	if not is_dashing:
		velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)
	
	# Dashing
	if Input.is_action_just_pressed("dash") and can_dash:
		_start_dash(direction)
	
	# Phase ability
	if Input.is_action_just_pressed("phase") and not is_phased and Global.phase_bought and not phase_timeout:
		enable_phase()
	elif Input.is_action_just_pressed("phase") and Global.phased_unlocked:
		disable_phase()
	
	move_and_slide()

func enable_phase():
	is_phased = true
	phase_timeout = true
	collision_shape.disabled = true
	$PhaseTimeout.start()
	$Phaseout.start()

func disable_phase():
	collision_shape.disabled = false
	is_phased = false

func _start_dash(direction: float):
	can_dash = false
	is_dashing = true
	velocity = Vector2(
		direction if direction != 0 else sign(velocity.x) if velocity.x != 0 else 1, 0
	) * DASH_SPEED
	
	dash_timer.start(DASH_DURATION)
	dash_cooldown_timer.start(DASH_COOLDOWN)
	collision_shape.disabled = Global.phase_bought

func _end_dash():
	is_dashing = false
	collision_shape.disabled = false

func _enable_dash():
	can_dash = true

func respawn():
	global_position = respawn_position
	is_dead = false
	visible = true
	collision_shape.disabled = false
	velocity = Vector2.ZERO

func _on_respawn_countdown_complete():
	respawn()

func _on_timer_timeout():
	disable_phase()
	print("Phase timed out")

func _on_can_phase_timeout():
	phase_timeout = false

func update_respawn_position(new_position: Vector2):
	respawn_position = new_position

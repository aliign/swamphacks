extends CharacterBody2D
class_name Player

const SPEED = 80.0
const JUMP_VELOCITY = -250
@export var CROUCH_MULT : float = 0.5
@onready var animated_sprite_2d: Sprite2D = $AnimatedSprite2D
@onready var dashcd: Timer = $dashcd
@onready var dashdur: Timer = $dashdur
@onready var standbox: CollisionShape2D = $CollisionShape2D
@onready var crouchbox: CollisionShape2D = $crouchbox
@onready var iscrouch: RayCast2D = $iscrouch
@export var dash_curve : Curve


var input_vector : Vector2 = Vector2.ZERO
func handle_input() -> void:
	input_vector = Input.get_vector("move_left", "move_right", "up", "crouch")

	jump_pressed_frames_ago += 1
	if (Input.is_action_just_pressed("jump")):
		jump_pressed_frames_ago = 0

@export_group("Horizontal Movement")
@export_subgroup("Grounded")
@export var ground_max_speed : int = 1000				## ground max speed in pixels/second
@export var ground_acceleration_frames : int = 5	## time it takes to accelerate to max speed whilst grounded
@onready var ground_acceleration : int = int(ground_max_speed / ground_acceleration_frames)
@export var ground_deceleration_frames : int = 5	## time it takes to decelerate to zero whilst grounded
@onready var ground_deceleration : int = int (ground_max_speed / ground_acceleration_frames)
@export_subgroup("Airborne")
@export var air_max_speed : int = 1000					## air max speed in pixels/second
@export var air_acceleration_frames : int = 5		## time it takes to accelerate to max speed whilst airborne
@onready var air_acceleration : int = int(air_max_speed / air_acceleration_frames)
@export var air_deceleration_frames : int = 5		## time it takes to decelerate to zero whilst airborne
@onready var air_deceleration : int = int(air_max_speed / air_acceleration_frames)

var apex_multiplier : float = 1.0
func handle_horizontal_movement() -> void:
	if input_vector.x == 0:
		var deceleration = ground_deceleration if is_on_floor() else air_deceleration
		velocity.x = move_toward(velocity.x, 0, deceleration * apex_multiplier)
	else:
		var acceleration = ground_acceleration if is_on_floor() else air_acceleration
		var max_speed = ground_max_speed if is_on_floor() else air_max_speed
		if is_on_floor():
			velocity.x = move_toward(velocity.x, input_vector.x * max_speed, acceleration)
		else:
			velocity.x = move_toward(velocity.x, input_vector.x * max_speed * apex_multiplier, acceleration * apex_multiplier)

@export_group("Leniency")
@export var input_buffer_frames : int = 4
@onready var jump_pressed_frames_ago : int = input_buffer_frames + 1
@export var coyote_frames : int = 4
@onready var grounded_frames_ago : int = coyote_frames + 1

@export_group("Jumping")
@export var jump_height : int = 400						## jump height in pixels
@export var jump_ascent_time : float = 0.3				## time until jump peak in seconds
@onready var jump_ascent_time_frames : int = int(jump_ascent_time * Engine.physics_ticks_per_second)
@export var jump_descent_time : float = 0.25				## time from peak to ground
@onready var jump_descent_time_frames : int = int(jump_descent_time * Engine.physics_ticks_per_second)
@onready var jump_velocity : int = -int((-2.0 * jump_height) / jump_ascent_time)
@onready var jump_ascent_gravity : int = -int((-2.0 * jump_height) / (jump_ascent_time * jump_ascent_time))
@onready var jump_descent_gravity : int = -int((-2.0 * jump_height) / (jump_descent_time * jump_descent_time))
@export var variable_jump_gravity : float = 2.0			## amount to multiply the gravity by if the jump is ended early
@export_subgroup("Apex Modifiers")
@export var apex_duration : float = 0.2					## amount of time that apex modifiers apply for, as seconds, centered on the peak of the jump and split evenly
@onready var apex_duration_frames : int = int(apex_duration * Engine.physics_ticks_per_second)
@export var apex_bonus_speed : float = 1.1					## amount to multiply horizontal speed by at jump apex
@export var apex_gravity : float = 0.75					## amount to multiply the gravity by at the apex of the jump
@export_subgroup("Fall Speed")
@export var max_fall_speed : int = 3000					## maximum falling speed
@export_subgroup("Jump Boost")
@export var jump_boost : int = 100						## amount to accelerate the player by when jumping

var jumped_frames_ago : int = jump_ascent_time_frames + apex_duration_frames + jump_descent_time_frames
var jump_ended_early : bool = false
func handle_jump(delta) -> void:
	grounded_frames_ago += 1
	jumped_frames_ago += 1
	var gravity : int = jump_ascent_gravity * delta if velocity.y < 0.0 else jump_descent_gravity * delta
	if not is_on_floor() and (jumped_frames_ago > jump_ascent_time_frames - (apex_duration_frames * 0.5) and jumped_frames_ago < jump_ascent_time_frames + (apex_duration_frames * 0.5)):
		gravity *= apex_gravity
		apex_multiplier = apex_bonus_speed
	else:
		apex_multiplier = 1.0
	if is_on_floor():
		jump_ended_early = false
		grounded_frames_ago = 0
	else:
		if jump_ended_early and velocity.y < 0.0: gravity *= variable_jump_gravity
		velocity.y = move_toward(velocity.y, max_fall_speed, gravity)
	
	jump_pressed_frames_ago += 1
	if Input.is_action_just_pressed("jump"):
		jump_pressed_frames_ago = 0
	if Input.is_action_just_released("jump"):
		jump_ended_early = true
	if jump_pressed_frames_ago < input_buffer_frames and grounded_frames_ago < coyote_frames:
		jumped_frames_ago = 0
		grounded_frames_ago = coyote_frames + 1
		velocity.x += jump_boost * sign(input_vector.x)
		velocity.y = -jump_velocity
	
	velocity.y = clamp(velocity.y, -INF, max_fall_speed)

func _physics_process(delta: float) -> void:
	handle_input()
	handle_horizontal_movement()
	handle_jump(delta)

	if !dashdur.is_stopped():
		velocity.x = dash_curve.sample(dashdur.wait_time - dashdur.time_left) * SPEED * input_vector.x
	else:
		if input_vector.x>0:
			animated_sprite_2d.flip_h=false
		elif input_vector.x<0:
			animated_sprite_2d.flip_h=true
		if is_on_floor():
			if input_vector.x==0:
				if Input.is_action_pressed("crouch") or iscrouch.is_colliding():
					animated_sprite_2d.scale.y = 0.01
					crouchbox.set_deferred("disabled", false)
					standbox.set_deferred("disabled", true)
					global_position.y+=2.0
				else:
					animated_sprite_2d.scale.y = 0.02
					crouchbox.set_deferred("disabled", true)
					standbox.set_deferred("disabled", false)
			else:
				if Input.is_action_pressed("crouch") or iscrouch.is_colliding():
					animated_sprite_2d.scale.y = 0.01
					crouchbox.set_deferred("disabled", false)
					standbox.set_deferred("disabled", true)
				else:
					animated_sprite_2d.scale.y = 0.02
					crouchbox.set_deferred("disabled", true)
					standbox.set_deferred("disabled", false)
		else:
			crouchbox.set_deferred("disabled", true)
			standbox.set_deferred("disabled", false)
		
		if input_vector.x:
			if Input.is_action_pressed("crouch") and is_on_floor():
				velocity.x = input_vector.x * SPEED * CROUCH_MULT
			elif Input.is_action_pressed("dash"):
				if dashcd.is_stopped():
					dashcd.start()
					dashdur.start()
	move_and_slide()

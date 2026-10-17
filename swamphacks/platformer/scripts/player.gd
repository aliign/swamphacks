extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	var down:= Input.get_axis("crouch", "jump")	
	if direction>0:
		animated_sprite_2d.flip_h=false
	elif direction<0:
		animated_sprite_2d.flip_h=true
		
	if is_on_floor():
		if direction==0:
			if Input.is_action_pressed("crouch"):
				animated_sprite_2d.play("crouch")
			else:
				animated_sprite_2d.play("idle")
		else:
			if Input.is_action_pressed("crouch"):
				animated_sprite_2d.play("crouch_run")
			else:
				animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	
	if direction:
		if Input.is_action_pressed("crouch"):
			velocity.x = direction * SPEED * 0.5
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

extends CharacterBody2D
class_name Player

const SPEED = 130.0
const JUMP_VELOCITY = -250
const DASH_MULT = 3
const CROUCH_MULT = 0.5
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dashcd: Timer = $dashcd
@onready var dashdur: Timer = $dashdur
@onready var jumpcd: Timer = $jumpcd


func _physics_process(delta: float) -> void:
	if !dashdur.is_stopped():
		velocity.y = 0
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if Input.is_action_just_pressed("jump") and is_on_floor() and jumpcd.is_stopped():
			velocity.y = JUMP_VELOCITY
			jumpcd.start()

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
					global_position.y+=2.0
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
				velocity.x = direction * SPEED * CROUCH_MULT
			elif Input.is_action_pressed("dash"):
				if dashcd.is_stopped():
					dashcd.start()
					dashdur.start()
					velocity.x = direction * SPEED * DASH_MULT
				else:
					if dashdur.is_stopped():
						velocity.x= direction * SPEED
			else:
				velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

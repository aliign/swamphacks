extends CharacterBody2D
class_name Player

const SPEED = 80.0
const JUMP_VELOCITY = -210
const CROUCH_MULT = 0.5
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dashcd: Timer = $dashcd
@onready var dashdur: Timer = $dashdur
@onready var standbox: CollisionShape2D = $CollisionShape2D
@onready var crouchbox: CollisionShape2D = $crouchbox
@onready var iscrouch: RayCast2D = $iscrouch
@export var dash_curve : Curve

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if !dashdur.is_stopped():
		velocity.y = 0
		velocity.x = dash_curve.sample(dashdur.wait_time - dashdur.time_left) * SPEED * direction
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var down:= Input.get_axis("crouch", "jump")	
		if direction>0:
			animated_sprite_2d.flip_h=false
		elif direction<0:
			animated_sprite_2d.flip_h=true
		if is_on_floor():
			if direction==0:
				if Input.is_action_pressed("crouch") or iscrouch.is_colliding():
					animated_sprite_2d.play("crouch")
					crouchbox.set_deferred("disabled", false)
					standbox.set_deferred("disabled", true)
					global_position.y+=2.0
				else:
					animated_sprite_2d.play("idle")
					crouchbox.set_deferred("disabled", true)
					standbox.set_deferred("disabled", false)
			else:
				if Input.is_action_pressed("crouch") or iscrouch.is_colliding():
					animated_sprite_2d.play("crouch_run")
					crouchbox.set_deferred("disabled", false)
					standbox.set_deferred("disabled", true)
				else:
					animated_sprite_2d.play("run")
					crouchbox.set_deferred("disabled", true)
					standbox.set_deferred("disabled", false)
		else:
			animated_sprite_2d.play("jump")
			crouchbox.set_deferred("disabled", true)
			standbox.set_deferred("disabled", false)
		
		if direction:
			if Input.is_action_pressed("crouch"):
				velocity.x = direction * SPEED * CROUCH_MULT
			elif Input.is_action_pressed("dash"):
				if dashcd.is_stopped():
					dashcd.start()
					dashdur.start()
				else:
					if dashdur.is_stopped():
						velocity.x= direction * SPEED
			else:
				velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

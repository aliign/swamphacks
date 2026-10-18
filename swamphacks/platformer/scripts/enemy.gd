extends Node2D

const SPEED=215
@onready var rcleft: RayCast2D = $rcleft
@onready var rcright: RayCast2D = $rcright
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2
@onready var animated_sprite_2d_3: AnimatedSprite2D = $AnimatedSprite2D3

var direction=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rcleft.is_colliding():
		if rcleft.get_collider() is Player:
			return
		direction = -1
		animated_sprite_2d.flip_h=false
		animated_sprite_2d_2.flip_h=false
		animated_sprite_2d_3.flip_h=false
	if rcright.is_colliding():
		if rcright.get_collider() is Player:
			return
		direction = 1
		animated_sprite_2d.flip_h=true
		animated_sprite_2d_2.flip_h=true
		animated_sprite_2d_3.flip_h=true
	position.x+=direction*SPEED*delta

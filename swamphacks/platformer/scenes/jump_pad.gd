extends Node2D

@export var strength : int = 500

func on_body_enter(body : Node2D) -> void:
	if body is Player:
		body.velocity.y -= strength
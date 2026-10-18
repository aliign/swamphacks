extends StaticBody2D

@export var alternate : bool = false
@export var flash : Node

func _ready() -> void:
	if alternate:
		$Sprite2D.visible = false
		collision_layer = 8

func on_timer_timeout() -> void:
	$Sprite2D.visible = not $Sprite2D.visible
	collision_layer = 8 if not $Sprite2D.visible else 1

func _process(delta: float) -> void:
	if flash:
		flash.visible = $Sprite2D.visible
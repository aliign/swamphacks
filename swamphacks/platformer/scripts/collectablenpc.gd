extends CharacterBody2D
class_name collectable

var inside: bool=false
@onready var collectablenpc: CharacterBody2D = $".."

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if inside:
			pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		inside=true
		
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		inside=false

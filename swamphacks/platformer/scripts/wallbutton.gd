extends Area2D
var inside: bool=false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if inside:
			queue_free()
			
func _on_body_entered(body: Node2D) -> void:
	print("entered")
	if body is Player:
		print("true")
		inside=true
		
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		inside=false

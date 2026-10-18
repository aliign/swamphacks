extends Area2D
var inside: bool=false
@onready var tfencedoor_1: CollisionShape2D = $"../tfencedoor1/door/CollisionShape2D"
@onready var tlabel_1: Label = $"../tlabel1"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if inside:
			tfencedoor_1.disabled=true
			tlabel_1.text="good job!"
			queue_free()
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		inside=true
		
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		inside=false

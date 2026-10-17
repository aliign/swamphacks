extends Area2D
var inside: bool=false
@onready var tlabel_1: Label = $"../tlabel1"

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tlabel_1.show()
		inside=true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		tlabel_1.hide()
		inside=false

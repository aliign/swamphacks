extends Area2D
var inside: bool=false
@onready var tlabel_3: Label = $"../tlabel3"

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tlabel_3.show()
		inside=true

func _on_body_exited(body: Node2D) ->  void:
	if body is Player:
		tlabel_3.hide()
		inside=false

extends Area2D
var inside: bool=false
@onready var tlabel_2: Label = $"../tlabel2"

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tlabel_2.show()
		inside=true

func _on_body_exited(body: Node2D) ->  void:
	if body is Player:
		tlabel_2.hide()
		inside=false

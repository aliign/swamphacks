extends Area2D
class_name Collectable

var inside: bool=false
@onready var collectablenpc: CharacterBody2D = $".."

signal collected()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if inside:
			Globals.inventory.append("res://platformer/scenes/collectablenpc.tscn")
			collectablenpc.queue_free()
			collected.emit()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		inside=true
		
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		inside=false

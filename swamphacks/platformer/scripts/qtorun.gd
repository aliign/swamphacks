extends Area2D
var inside: bool=false
@onready var tlabel_5: Label = $"../tlabel5"
@onready var wallsprite: Sprite2D = $"../StaticBody2D/Sprite2D"
@onready var wallphysics: CollisionShape2D = $"../StaticBody2D/CollisionShape2D"
@onready var enemy: Node2D = $"../enemy"
@onready var tutorialend: Node = $"../tutorialend"

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		tlabel_5.show()
		wallsprite.show()
		wallphysics.set_deferred("disabled",false)
		enemy.show()
		enemy.process_mode=PROCESS_MODE_INHERIT
		tutorialend.begin()
		queue_free()

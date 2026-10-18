extends Area2D
@onready var label: Label = $"../../Label"
var inside: bool=false
@onready var door: StaticBody2D = $door

#func _on_body_entered(body: Node2D) -> void:
	#if body is Player:
		#label.show()
		#inside=true
		#
#func _on_body_exited(body: Node2D) -> void:
	#if body is Player:
		#label.hide()
		#inside=false
		#
#func interact(event: InputEvent) -> void:
	#if event.is_action_pressed("interact"):
		#if inside:
			#if door.disabled:
				#door.disabled=true
			#else:
				#door.disabled=true

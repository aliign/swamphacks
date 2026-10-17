@tool
extends Label

func _process(delta: float) -> void:
	self.position.x = -(size.x * 0.5)

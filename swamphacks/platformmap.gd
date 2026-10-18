extends Node2D

@export var player : Player
@export var t : Timer

signal timer
func on_timer():
	timer.emit()

func _process(delta: float) -> void:
	%Label.text = "%02d" % [str(t.time_left)]
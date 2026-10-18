extends Node2D

@export var player : Player
@export var t : Timer

signal timer
func on_timer():
	timer.emit()

extends Node2D

@export var player : Player

signal timer
func on_timer():
	timer.emit()

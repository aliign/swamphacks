extends Node
@onready var timer: Timer = $Timer

func begin() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	print("win")
	get_tree().change_scene_to_file("res://platformer/scenes/gameend.tscn")

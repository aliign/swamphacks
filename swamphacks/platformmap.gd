extends Node2D
@onready var gametime: Timer = $gametime
@onready var timer: Label = $CanvasLayer/Control/Label
var started: bool = false
var time: int = 60

func _ready() -> void:
	%gametime.wait_time = (Globals.level + 1) * 10
	for collectable in get_tree().get_nodes_in_group("Collectables"):
		if collectable is CharacterBody2D:
			collectable.connect("collected", on_collected)

func _process(delta: float) -> void:
	timer.text = "%.2f" % gametime.time_left
	
func on_collected():
	if !started:
		started=true
		timer.show()
		gametime.start()
		
func _on_gametime_timeout() -> void:
	timer.queue_free()
	match Globals.level:
		0:
			get_tree().change_scene_to_file("res://autobattler/guys/level_1_autobattler.tscn")
		1:
			get_tree().change_scene_to_file("res://autobattler/guys/level_2_autobattler.tscn")
		2:
			get_tree().change_scene_to_file("res://autobattler/guys/level_3_autobattler.tscn")
		3:
			get_tree().change_scene_to_file("res://autobattler/guys/level_4_autobattler.tscn")

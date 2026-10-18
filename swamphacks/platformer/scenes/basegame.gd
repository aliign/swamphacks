extends Node2D
@onready var gametime: Timer = $gametime
@onready var timer: Label = $CanvasLayer/Control/Label
var started: bool = false
var time: int = 60
var timepassed: float = 60

func _ready() -> void:
	for collectable in get_tree().get_nodes_in_group("Collectables"):
		if collectable is CharacterBody2D:
			collectable.connect("collected", on_collected)

func _process(delta: float) -> void:
	if !gametime.is_stopped():
		timepassed -= delta
		updatetext()

func updatetext() -> void:
	var seconds: int = int(timepassed) % 60
	var milliseconds: int = int((timepassed - int(timepassed)) * 100)
	timer.text = "%02d:%02d" % [seconds, milliseconds]
	
func on_collected():
	if !started:
		started=true
		timer.show()
		gametime.start()
		
func _on_gametime_timeout() -> void:
	timer.queue_free()
	get_tree().change_scene_to_file("res://platformer/scenes/platformer_1.tscn")

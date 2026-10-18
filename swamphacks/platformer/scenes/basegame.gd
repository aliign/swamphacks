extends Node2D
@onready var gametime: Timer = $gametime
var started: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for collectable in get_tree().get_nodes_in_group("Collectables"):
		collectable.connect("collected", on_collected)

func on_collected():
	if !started:
		gametime.begin()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

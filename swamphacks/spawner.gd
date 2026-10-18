extends Node2D


@export var spawns : Array[String] = []

func _ready() -> void:
	var npc = load(spawns.pick_random()).instantiate()
	self.add_child(npc)
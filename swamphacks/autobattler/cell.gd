extends Control
class_name Cell

@export var adjacency_list : Array[Cell] = []
@export_enum("Player", "Enemy") var team : int = 0
@export var ally : Ally
@export var center : Vector2:
	get():
		return (self.size / 2) + self.global_position
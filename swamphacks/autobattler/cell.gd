extends Control
class_name Cell

@export var adjacency_list : Array[Cell] = []
@export var adj_up : Cell
@export var adj_down : Cell
@export var adj_left : Cell
@export var adj_right : Cell
@export_enum("Player", "Enemy") var team : int = 0
@export var ally : Ally
var center : Vector2 = global_position + (size * 0.5):
	get():
		return global_position + (size * 0.5)

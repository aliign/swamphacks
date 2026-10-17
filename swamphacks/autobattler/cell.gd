extends Control
class_name Cell

@export var adjacency_list : Array[Cell] = []
@export_enum("Player", "Enemy") var team : int = 0
@export var ally : Ally

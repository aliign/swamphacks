extends Control

var ally_list : Array[Ally]
func start_battle() -> void:
	for ally in ally_list:
		ally.start_battle()

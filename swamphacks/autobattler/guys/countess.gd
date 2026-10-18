extends Ally

func on_battle_start(ally : Ally) -> void:
	if ally != self: return
	for cell in get_closest_cell().adjacency_list:
		cell.ally.magic *= 2
		cell.ally.shield *= 2

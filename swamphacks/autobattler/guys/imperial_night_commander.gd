extends Ally

func on_battle_start(ally : Ally) -> void:
	if ally != self: return
	var alone : bool = true
	for cell in get_closest_cell().adjacency_list:
		if cell.ally != null:
			alone = false
	if alone:
		damage *= 5
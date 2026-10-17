extends Ally

func on_battle_start(ally : Ally) -> void:
	for i in get_closest_cell().adjacency_list:
		i.ally.damage += 5
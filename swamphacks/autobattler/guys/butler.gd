extends Ally

func on_battle_end(ally : Ally) -> void:
	if get_closest_cell().adj_right.ally.rank == Globals.COMMONER:
		get_closest_cell().adj_right.ally.perm_multicast += 1

extends Ally

func on_battle_end(ally : Ally) -> void:
	if not get_closest_cell(): return
	if get_closest_cell().adj_right.ally.rank == Globals.rank.COMMONER:
		get_closest_cell().adj_right.ally.perm_multicast += 1

extends Ally

func on_battle_start(ally : Ally) -> void:
	if ally != self: return
	if !get_closest_cell(): return
	if get_closest_cell().adj_down.ally:
		multicast += 1 if get_closest_cell().adj_down.ally.fire > 0 else 0

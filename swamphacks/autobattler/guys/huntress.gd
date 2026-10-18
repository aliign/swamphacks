extends Ally

func on_battle_start(ally : Ally) -> void:
	if ally != self: return
	for i in get_tree().get_nodes_in_group("Cells"):
		if i.left_column == false and i.team == self.team:
			if i.ally:
				i.ally.fire *= 2
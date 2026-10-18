extends Ally

func on_battle_start(ally : Ally) -> void:
	if ally != self: return
	var ranks : Array[int]
	for i in get_tree().get_nodes_in_group("Allies"):
		if not ranks.has(i.rank):
			ranks.append(i.rank)
	for cell in get_closest_cell().adjacency_list:
		var next_ally : Ally = cell.ally
		if next_ally:
			next_ally.damage += len(ranks) if next_ally.damage > 0 else 0
			next_ally.fire += len(ranks) if next_ally.fire > 0 else 0
			next_ally.poison += len(ranks) if next_ally.poison > 0 else 0
			next_ally.holy += len(ranks) if next_ally.holy > 0 else 0
			next_ally.magic += len(ranks) if next_ally.magic > 0 else 0
			next_ally.shield += len(ranks) if next_ally.shield > 0 else 0
			next_ally.healing += len(ranks) if next_ally.healing > 0 else 0
			next_ally.multicast += len(ranks) if next_ally.multicast > 1 else 0

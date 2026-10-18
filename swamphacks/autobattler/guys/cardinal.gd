extends Ally

func cast() -> void:
	for cell in get_closest_cell().adjacency_list:
		var ally : Ally = cell.ally
		if ally:
			holy = perm_holy + ally.healing
	for i in multicast:
		target.take_damage(damage)
		target.take_magic_damage(magic)
		target.add_poison(poison)
		target.add_fire(fire)
		target.add_holy(holy)
		player.add_health(healing)
		player.add_shield(shield)
		animation_player.stop()
		if team == 0: animation_player.play("attack")
		else: animation_player.play("enemy_attack")
		casted.emit(self)
		await get_tree().create_timer(0.1).timeout
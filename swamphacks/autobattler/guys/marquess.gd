extends Ally

func cast() -> void:
	player.poison -= poison
	for i in multicast + 1:
		target.take_damage(damage)
		target.take_magic_damage(magic)
		target.add_poison(poison)
		target.add_fire(fire)
		target.add_holy(holy)
		player.add_health(healing)
		player.add_shield(shield)
		if team == 0: animation_player.play("attack")
		else: animation_player.play("enemy_attack")
		casted.emit(self)
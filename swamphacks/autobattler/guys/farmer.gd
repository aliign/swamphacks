extends Ally

func cast() -> void:
	var dmg : int = damage
	if player.health <= player.max_health * 0.5:
		dmg *= 2
	for i in multicast:
		target.take_damage(dmg)
		target.take_magic_damage(magic)
		target.add_poison(poison)
		target.add_fire(fire)
		target.add_holy(holy)
		player.add_health(healing)
		player.add_shield(shield)
		if team == 0: animation_player.play("attack")
		else: animation_player.play("enemy_attack")
		casted.emit(self)
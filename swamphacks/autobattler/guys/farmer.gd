extends Ally

var doubled : bool = false
func cast() -> void:
	if player.health <= player.max_health * 0.5 and not doubled:
		damage = damage * 2
		doubled = true
	for i in multicast:
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
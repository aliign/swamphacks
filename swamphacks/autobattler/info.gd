extends Control

var ally : Ally = null
func _process(delta: float) -> void:
	ally = Globals.highlighted_ally
	if ally:
		self.visible = true
		%Sprite.texture = ally.sprite.texture
		%Name.text = ally.name.capitalize()
		%Rank.text = Globals.rank.keys()[ally.rank].capitalize()
		%DamageLabel.value = ally.perm_damage
		%MagicLabel.value = ally.perm_magic
		%PoisonLabel.value = ally.perm_poison
		%FireLabel.value = ally.perm_fire
		%HolyLabel.value = ally.perm_holy
		%ShieldLabel.value = ally.perm_shield
		%HealLabel.value = ally.perm_healing
		%MulticastLabel.value = ally.perm_multicast
		%Description.text = ally.description
		%DamageDescription.visible = true if ally.damage > 0 else false
		%MagicDescription.visible = true if ally.magic > 0 else false
		%FireDescription.visible = true if ally.fire > 0 else false
		%PoisonDescription.visible = true if ally.poison > 0 else false
		%HolyDescription.visible = true if ally.holy > 0 else false
		%ShieldDescription.visible = true if ally.shield > 0 else false
		%HealingDescription.visible = true if ally.healing > 0 else false
		%MulticastDescription.visible = true if ally.multicast > 1 else false
		%CooldownLabel.text = "%0.1f" % ally.cooldown if ally.multicast > 0 else "N/A"
	else:
		self.visible = false

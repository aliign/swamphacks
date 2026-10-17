extends Node2D
class_name Ally

@export_category("Targets")
@export var player : BattlerPlayer
@export var target : BattlerPlayer

@export_category("Details")
@export var art : Texture2D

@export_category("Mechanics")
@export var cooldown : float:
	set(value):
		cooldown = value if value >= 1.0 else 1.0
@export var multicast : int:
	set(value):
		multicast = value if value >=1 else 1

@export_category("Damage")
@export var damage : int:
	set(value):
		damage = value if value >= 0 else 0
@export var poison : int:
	set(value):
		poison = value if value >= 0 else 0
@export var fire : int:
	set(value):
		fire = value if value >= 0 else 0
@export var magic : int:
	set(value):
		magic = value if value >= 0 else 0
@export var holy : int:
	set(value):
		holy = value if value >= 0 else 0
@export var shield : int:
	set(value):
		shield = value if value >= 0 else 0
@export var healing : int:
	set(value):
		healing = value if value >= 0 else 0


@onready var sprite : Sprite2D = %Sprite
@onready var timer : Timer = %Timer

func _ready() -> void:
	sprite.texture = art
	timer.wait_time = cooldown

signal casted(caster : Ally)
func cast() -> void:
	target.take_damage(damage)
	target.take_magic_damage(magic)
	target.add_poison(poison)
	target.add_fire(fire)
	target.add_holy(holy)
	player.add_health(healing)
	player.add_shield(shield)
	casted.emit(self)

signal started_battle(caster : Ally)
func battle_start() -> void:
	started_battle.emit(self)

signal ended_battle(caster : Ally)
func battle_end() -> void:
	ended_battle.emit(self)
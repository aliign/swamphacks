extends Node2D
class_name Ally

@export_category("Targets")
@export_enum("Player", "Enemy") var team : int = 0
@export var player : BattlerPlayer
@export var target : BattlerPlayer

@export_category("Details")
@export var art : Texture2D
@export var description : String

@export_category("Mechanics")
@export var cooldown : float = 1.0:
	set(value):
		cooldown = value if value >= 1.0 else 1.0
@export var multicast : int:
	set(value):
		multicast = value if value >=1 else 1

@export_category("Damage")
@export var damage : int:
	set(value):
		damage = value if value >= 0 else 0
		update_display()
@export var poison : int:
	set(value):
		poison = value if value >= 0 else 0
		update_display()
@export var fire : int:
	set(value):
		fire = value if value >= 0 else 0
		update_display()
@export var magic : int:
	set(value):
		magic = value if value >= 0 else 0
		update_display()
@export var holy : int:
	set(value):
		holy = value if value >= 0 else 0
		update_display()
@export var shield : int:
	set(value):
		shield = value if value >= 0 else 0
		update_display()
@export var healing : int:
	set(value):
		healing = value if value >= 0 else 0
		update_display()

func update_display():
	%DamageLabel.value = damage
	%MagicLabel.value = magic
	%PoisonLabel.value = poison
	%FireLabel.value = fire
	%HolyLabel.value = holy
	%ShieldLabel.value = shield
	%HealLabel.value = healing

@onready var sprite : Sprite2D = %Sprite
@onready var timer : Timer = %Timer

func _ready() -> void:
	sprite.texture = art
	update_display()

func _process(delta: float) -> void:
	%CooldownBar.value = %Timer.wait_time

@onready var original_scale : Vector2 = sprite.scale
var hovering : bool = false:
	set(value):
		hovering = value
		sprite.scale = original_scale * 1.1 if hovering else original_scale
		#if hovering:
		#	(sprite.material as ShaderMaterial).set_shader_parameter("outline_width", 0.02)
		#else:
		#	(sprite.material as ShaderMaterial).set_shader_parameter("outline_width", 0.0)

func mouse_start_hover() -> void:
	hovering = true

func mouse_end_hover() -> void:
	hovering = false

var clicked : bool = false
func _physics_process(delta: float) -> void:
	if hovering and not in_battle and team == 0:
		if Input.is_action_just_pressed("click"):
			clicked = true
			var cell : Cell = get_closest_cell()
			if cell.ally == self:
				cell.ally = null
	if clicked and not in_battle and team == 0:
		self.position = get_viewport().get_mouse_position()
	if Input.is_action_just_released("click"):
		clicked = false
		self.global_position = get_closest_cell().center

func get_closest_cell() -> Cell:
	var closest_cell : Cell = null
	var closest_dist : float = INF
	for cell in get_tree().get_nodes_in_group("Cells"):
		var dist = self.global_position.distance_squared_to(cell.global_position)
		if dist < closest_dist and (cell.ally == self or cell.ally == null):
			closest_dist = dist
			closest_cell = cell
	return closest_cell

@onready var animation_player : AnimationPlayer = %AnimationPlayer
signal casted(caster : Ally)
func cast() -> void:
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

func on_cast(ally : Ally) -> void:
	pass

var in_battle : bool = false
signal started_battle(caster : Ally)
func battle_start() -> void:
	%CooldownBar.visible = true
	timer.start()
	in_battle = true
	started_battle.emit(self)

func on_battle_start(ally : Ally) -> void:
	pass

signal ended_battle(caster : Ally)
func battle_end() -> void:
	%CooldownBar.visible = false
	in_battle = false
	ended_battle.emit(self)

func on_battle_end(ally : Ally) -> void:
	pass

func fire_changed() -> void:
	pass

func poison_changed() -> void:
	pass

func holy_changed() -> void:
	pass

func health_changed() -> void:
	pass

func shield_changed() -> void:
	pass
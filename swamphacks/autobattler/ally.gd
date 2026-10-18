extends Node2D
class_name Ally

@export_category("Targets")
@export_enum("Player", "Enemy") var team : int = 0
@export var player : BattlerPlayer
@export var target : BattlerPlayer

@export_category("Details")
@export var rank : Globals.rank = Globals.rank.COMMONER
@export var description : String

@export_category("Mechanics")
@export var perm_cooldown : float = 1.0:
	set(value):
		perm_cooldown = value if value >= 1.0 else 1.0
		cooldown = perm_cooldown if perm_cooldown > cooldown else cooldown
		update_display()
@export var cooldown : float = 1.0:
	set(value):
		cooldown = value if value >= 1.0 else 1.0
		%Timer.wait_time = cooldown
@export var perm_multicast : int = 1:
	set(value):
		perm_multicast = value if value >= 0 else 1
		multicast = perm_multicast if perm_multicast > multicast else multicast
		update_display()
@export var multicast : int = 1:
	set(value):
		multicast = value if value >= 0 else 1
		update_display()

@export_category("Damage")
@export var perm_damage : int:
	set(value):
		perm_damage = value if value >= 0 else 0
		damage = perm_damage if perm_damage > damage else damage
		update_display()
@export var damage : int:
	set(value):
		damage = value if value >= 0 else 0
		update_display()
@export var perm_poison : int:
	set(value):
		perm_poison = value if value >= 0 else 0
		poison = perm_poison if perm_poison > poison else poison
		update_display()
@export var poison : int:
	set(value):
		poison = value if value >= 0 else 0
		update_display()
@export var perm_fire : int:
	set(value):
		perm_fire = value if value >= 0 else 0
		fire = perm_fire if perm_fire > fire else fire
		update_display()
@export var fire : int:
	set(value):
		fire = value if value >= 0 else 0
		update_display()
@export var perm_magic : int:
	set(value):
		perm_magic = value if value >= 0 else 0
		magic = perm_magic if perm_magic > magic else magic
		update_display()
@export var magic : int:
	set(value):
		magic = value if value >= 0 else 0
		update_display()
@export var perm_holy : int:
	set(value):
		perm_holy = value if value >= 0 else 0
		holy = perm_holy if perm_holy > holy else holy
		update_display()
@export var holy : int:
	set(value):
		holy = value if value >= 0 else 0
		update_display()
@export var perm_shield : int:
	set(value):
		perm_shield = value if value >= 0 else 0
		shield = perm_shield if perm_shield > shield else shield
		update_display()
@export var shield : int:
	set(value):
		shield = value if value >= 0 else 0
		update_display()
@export var perm_healing : int:
	set(value):
		perm_healing = value if value >= 0 else 0
		healing = perm_healing if perm_healing > healing else healing
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
	%MulticastLabel.value = multicast - 1
	%CooldownBar.max_value = cooldown

@onready var sprite : Sprite2D = %Sprite
@onready var timer : Timer = %Timer

func _ready() -> void:
	update_display()
	await get_tree().create_timer(0.1).timeout
	self.global_position = get_closest_cell().center
	get_closest_cell().ally = self
	if team != 0:
		sprite.scale.x *= -1

func _process(delta: float) -> void:
	%CooldownBar.value = %Timer.time_left

@onready var original_scale : Vector2 = sprite.scale
var hovering : bool = false:
	set(value):
		hovering = value
		sprite.scale = original_scale * 1.1 if hovering else original_scale
		if team != 0:
			sprite.scale.x *= -1

func mouse_start_hover() -> void:
	hovering = true
	Globals.highlighted_ally = self

func mouse_end_hover() -> void:
	hovering = false
	Globals.highlighted_ally = null

var clicked : bool = false
func _physics_process(delta: float) -> void:
	z_index = 2 if clicked else 0
	if hovering and (not in_battle) and team == 0:
		if Input.is_action_just_pressed("click"):
			clicked = true
			var cell : Cell = get_closest_cell()
			if cell.ally == self:
				cell.ally = null
	if clicked and (not in_battle) and team == 0:
		self.position = get_viewport().get_mouse_position()
	if Input.is_action_just_released("click") and (not in_battle) and team == 0 and hovering:
		clicked = false
		var closest_cell : Cell = get_closest_cell()
		var dist_to_cell : float = self.global_position.distance_to(closest_cell.center)
		if dist_to_cell <= 100:
			self.global_position = get_closest_cell().center
			get_closest_cell().ally = self

func get_closest_cell() -> Cell:
	var closest_cell : Cell = null
	var closest_dist : float = INF
	for cell in get_tree().get_nodes_in_group("Cells"):
		if not cell is Cell or cell.team != team: continue
		var dist = self.global_position.distance_squared_to(cell.center)
		if dist < closest_dist and (cell.ally == self or cell.ally == null):
			closest_dist = dist
			closest_cell = cell
	return closest_cell

@onready var animation_player : AnimationPlayer = %AnimationPlayer
signal casted(caster : Ally)
func cast() -> void:
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

func on_cast(ally : Ally) -> void:
	pass

var in_battle : bool = false
signal battle_started(caster : Ally)
func battle_start() -> void:
	var closest_cell : Cell = get_closest_cell()
	if closest_cell.ally == self:
		%CooldownBar.visible = true if perm_multicast > 0 else false
		%CooldownBar.max_value = cooldown
		%Timer.wait_time = cooldown
		if perm_multicast > 0: timer.start()
		battle_started.emit(self)
	else:
		self.visible = false
	in_battle = true

func on_battle_start(ally : Ally) -> void:
	pass

signal battle_ended(caster : Ally)
func battle_end() -> void:
	%CooldownBar.visible = false
	in_battle = false
	battle_ended.emit(self)
	self.visible = true
	damage = perm_damage
	poison = perm_poison
	fire = perm_fire
	shield = perm_shield
	holy = perm_holy
	healing = perm_healing
	magic = perm_magic
	multicast = perm_multicast

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

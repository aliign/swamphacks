extends Control
class_name BattlerPlayer

@export_enum("Player", "Enemy") var team : int = 0
@export var target : BattlerPlayer

@onready var health_bar : ProgressBar = %HealthBar
@onready var health_label : Label = %HealthLabel
@onready var poison_timer : Timer = %PoisonTimer
@onready var fire_timer : Timer = %FireTimer

@export var max_health : int = 1000
@export var health : int = max_health:
	set(value):
		health = value if value < max_health else max_health
		if health <= 0:
			die()
		update_health_display()
		health_changed_signal_bus()
@export var shield : int = 0:
	set(value):
		shield = value if value >= 0 else 0
		update_health_display()
		%ShieldLabel.value = shield
		shield_changed_signal_bus()
@export var poison : int = 0:
	set(value):
		if poison == 0 and value > 0:
			poison_timer.start()
		poison = value if value >= 0 else 0
		update_health_display()
		%PoisonLabel.value = poison
		poison_changed_signal_bus()
@export var fire : int = 0:
	set(value):
		if fire == 0 and value > 0:
			fire_timer.start()
		fire = value if value >= 0 else 0
		update_health_display()
		%FireLabel.value = fire
		fire_changed_signal_bus()
@export var holy : int = 0:
	set(value):
		holy = value if value >= 0 else 0
		update_health_display()
		%HolyLabel.value = holy
		holy_changed_signal_bus()

var inventory_cells : Array[Cell] = []
func _ready() -> void:
	update_health_display()
	for cell in get_tree().get_nodes_in_group("Cells"):
		if cell.team == team:
			inventory_cells.append(cell)

var allies : Array[Ally] = []
func start_battle() -> void:
	for cell in inventory_cells:
		if cell.ally == null: continue
		allies.append(cell.ally)
	for ally in allies:
		ally.connect("casted", casted_signal_bus)
		ally.connect("battle_started", battle_started_signal_bus)
		ally.connect("battle_ended", battle_ended_signal_bus)
		ally.target = target
		ally.player = self
	for ally in get_tree().get_nodes_in_group("Allies"):
		ally.battle_start()

func casted_signal_bus(ally : Ally) -> void:
	for i in allies:
		i.on_cast(ally)

func battle_started_signal_bus(ally : Ally) -> void:
	for i in allies:
		i.on_battle_start(ally)

func battle_ended_signal_bus(ally : Ally) -> void:
	for i in allies:
		i.on_battle_end(ally)

func health_changed_signal_bus() -> void:
	for i in allies:
		i.health_changed()

func fire_changed_signal_bus() -> void:
	for i in allies:
		i.fire_changed()

func holy_changed_signal_bus() -> void:
	for i in allies:
		i.holy_changed()

func poison_changed_signal_bus() -> void:
	for i in allies:
		i.poison_changed()

func shield_changed_signal_bus() -> void:
	for i in allies:
		i.shield_changed()

func update_health_display() -> void:
	health_bar.max_value = max_health
	health_bar.value = health
	health_label.text = str(health)

signal died(player : BattlerPlayer)
func die():
	fire_timer.stop()
	poison_timer.stop()
	emit_signal("died", self)

func proc_poison():
	health -= poison

func proc_fire():
	var leftover : int = fire - shield
	shield -= fire
	if leftover > 0:
		health -= fire
	fire -= 1

func take_damage(damage):
	damage = damage + holy
	var leftover : int = damage - shield
	shield -= damage
	if leftover > 0:
		health -= leftover

func take_magic_damage(damage):
	health -= damage

func add_poison(amount):
	poison += amount

func add_fire(amount):
	fire += amount

func add_holy(amount):
	holy += amount

func add_health(amount):
	health += amount

func add_shield(amount):
	shield += amount

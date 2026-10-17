extends Control
class_name BattlerPlayer

@export_enum("Player", "Enemy") var team : int = 0

@onready var health_bar : ProgressBar = %HealthBar
@onready var health_label : Label = %HealthLabel
@onready var poison_label : Label = %PoisonLabel
@onready var fire_label : Label = %FireLabel
@onready var holy_label : Label = %HolyLabel
@onready var poison_timer : Timer = %PoisonTimer
@onready var fire_timer : Timer = %FireTimer

@export var max_health : int = 1000
@export var health : int = max_health:
	set(value):
		health = value if value < max_health else max_health
		if health <= 0:
			die()
		update_health_display()
@export var shield : int = 0:
	set(value):
		shield = value if value >= 0 else 0
		update_health_display()
		%ShieldLabel.value = shield
@export var poison : int = 0:
	set(value):
		if poison == 0 and value > 0:
			poison_timer.start()
		poison = value if value >= 0 else 0
		update_health_display()
		%PoisonLabel.value = poison
@export var fire : int = 0:
	set(value):
		if fire == 0 and value > 0:
			fire_timer.start()
		fire = value if value >= 0 else 0
		update_health_display()
		%FireLabel.value = fire
@export var holy : int = 0:
	set(value):
		holy = value if value >= 0 else 0
		update_health_display()
		%HolyLabel.value = holy

var inventory_cells : Array[Cell] = []
func _ready() -> void:
	for cell in get_tree().get_nodes_in_group("Cells"):
		if cell.team == team:
			inventory_cells.append(cell)

func update_health_display() -> void:
	health_bar.max_value = max_health
	health_bar.value = health
	health_label.text = str(health)

func die():
	fire_timer.stop()
	poison_timer.stop()

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

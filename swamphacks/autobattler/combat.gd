extends Control

@export var player : BattlerPlayer
@export var enemy : BattlerPlayer
@export var player_team : Array[PackedScene]
var in_battle : bool = false
func start_battle() -> void:
	if in_battle: return
	in_battle = true
	player.start_battle()
	enemy.start_battle()

func _ready() -> void:
	if Globals.inventory:
		for string in Globals.inventory:
			player_team.append(load(string))
	spawn_player_team()
	spawn_enemy_team()

func spawn_player_team() -> void:
	for i in player_team:
		var new_ally = i.instantiate()
		self.add_child(new_ally)
		new_ally.global_position = Vector2(1920,1080)*0.5
		new_ally.team = 0

@export var enemy_team : Array[PackedScene]
func spawn_enemy_team() -> void:
	for i in enemy_team:
		var new_ally = i.instantiate()
		self.add_child(new_ally)
		new_ally.team = 1

signal won
var already_won : bool = false
func win(node : BattlerPlayer):
	if already_won: return
	already_won = true
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(%Win, "position", Vector2.ZERO, 1.0)
	Globals.level += 1
	await tween.finished
	await get_tree().create_timer(1.5).timeout
	call_deferred("switch_to_main")

func lose(node : BattlerPlayer):
	if already_won: return
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(%Lose, "position", Vector2.ZERO, 1.0)
	%BattlerPlayer.fire = 0
	%BattlerPlayer.poison = 0
	%BattlerEnemy.fire = 0
	%BattlerEnemy.poison = 0
	for ally in get_tree().get_nodes_in_group("Allies"):
		ally.battle_end()

var quit : bool = false
func switch_to_main():
	if quit: return
	quit = true
	get_tree().change_scene_to_file("res://main.tscn")

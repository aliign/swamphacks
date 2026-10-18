extends Node2D

var level : int = 0
var scene
func timer():
	match level:
		1:
			scene = load("res://autobattler/guys/level_1_autobattler.tscn").instantiate()
		2:
			scene = load("res://autobattler/guys/level_2_autobattler.tscn").instantiate()
		3:
			scene = load("res://autobattler/guys/level_3_autobattler.tscn").instantiate()
		4:
			scene = load("res://autobattler/guys/level_4_autobattler.tscn").instantiate()
	add_child(scene)
	$Node2D.visible = false
	$Node2D.player.position = Vector2.ZERO
	level += 1
	$Node2D.t.wait_time += 20

func won():
	if level == 5:
		
		return
	$Node2D.visible = true
	$Node2D.player.position = Vector2.ZERO
	scene.queue_free()

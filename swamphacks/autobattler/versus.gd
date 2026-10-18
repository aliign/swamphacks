extends Control


func _ready() -> void:
	close()

var original_pos : Vector2
var shake : bool = false
func close() -> void:
	%VersusAnimationPlayer.play("close")
	original_pos = %SlashManager.position
	await get_tree().create_timer(1).timeout
	shake = true
	await get_tree().create_timer(1).timeout
	shake = false
	

func _physics_process(delta: float) -> void:
	if shake:
		%SlashManager.position = original_pos + Vector2(randi_range(-20,20), randi_range(-20,20))

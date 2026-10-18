extends AnimationPlayer

func _ready() -> void:
	var aniname = autoplay
	
	if aniname != "":
		play(aniname, -1, 1.0, false)
		seek(1.5, true) 

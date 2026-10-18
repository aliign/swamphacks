extends PanelContainer
class_name NumberDisplay

@export var color : Color
@export var multicast : bool = false

@export var value : int:
	set(amount):
		value = amount
		%Label.text = str(value)
		if not multicast:
			self.visible = value != 0
		else:
			self.visible = value > 1

var styleBox : StyleBoxFlat = get_theme_stylebox("panel").duplicate()
func _ready() -> void:
	styleBox.set("bg_color", color)
	add_theme_stylebox_override("panel", styleBox)

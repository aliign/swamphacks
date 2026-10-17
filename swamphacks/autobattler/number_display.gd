extends PanelContainer
class_name NumberDisplay

@export var color : Color

@export var value : int:
	set(amount):
		value = amount
		%Label.text = str(value)
		self.visible = value != 0

var styleBox : StyleBoxFlat = get_theme_stylebox("panel").duplicate()
func _ready() -> void:
	styleBox.set("bg_color", color)
	add_theme_stylebox_override("panel", styleBox)

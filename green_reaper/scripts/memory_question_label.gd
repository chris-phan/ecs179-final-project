class_name MemoryQuestionLabel
extends Label

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_handle_timeout)
	text = ""


func display(color: MemoryObject.Colors) -> void:
	var display_value: Dictionary = _get_display_value(color)
	text = display_value["name"].to_upper()
	set("theme_override_colors/font_color", display_value["font_color"])
	timer.start()


func _get_display_value(color: MemoryObject.Colors) -> Dictionary:
	return {
		"name": MemoryObject.get_color_name(color),
		"font_color": _get_random_color(),
	}


func _get_random_color() -> Color:
	var rand_color: MemoryObject.Colors = MemoryObject.Colors.values().pick_random()
	var color_name: String = MemoryObject.get_color_name(rand_color)
	return Color(color_name)


func _handle_timeout() -> void:
	text = ""

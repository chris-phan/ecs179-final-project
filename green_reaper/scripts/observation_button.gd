class_name ObservationButton
extends Area2D

var _val: int = 0
@onready var label: Label = $Label


func _ready() -> void:
	area_entered.connect(_handle_area_entered)


func set_val(v: int) -> void:
	_val = v
	label.text = str(_val)


func _handle_area_entered(area: Area2D) -> void:
	signal_bus.hit_observation_button.emit(_val)

class_name StopTimerObject
extends Area2D


func _ready() -> void:
	area_entered.connect(_handle_area_entered)


func _handle_area_entered(_area: Area2D) -> void:
	signal_bus.hit_stop_timer_button.emit()

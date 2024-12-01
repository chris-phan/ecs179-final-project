class_name PlatformingGoal
extends Area2D


func _ready() -> void:
	connect("body_entered", _handle_body_entered)


func _handle_body_entered(_body: Node2D) -> void:
	signal_bus.reached_platforming_goal.emit()

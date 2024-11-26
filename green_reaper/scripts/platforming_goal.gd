class_name PlatformingGoal
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _handle_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _handle_body_entered(_body: Node2D) -> void:
	signal_bus.reached_platforming_goal.emit()

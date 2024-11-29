class_name Minigame
extends Node2D

enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
}

var _difficulty: Difficulty = Difficulty.HARD
@onready var countdown_label: CountdownLabel = $CountdownLabel


func init() -> void:
	signal_bus.countdown_ended.connect(_handle_countdown_ended)


func _start() -> void:
	pass


func _win() -> void:
	pass


func _lose() -> void:
	pass


func _handle_countdown_ended() -> void:
	pass

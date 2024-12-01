class_name Minigame
extends Node2D

enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
}

var minigame_name: String
var instructions: String

var _difficulty: Difficulty = Difficulty.HARD
@onready var countdown_label: CountdownLabel = $CountdownLabel


func init() -> void:
	signal_bus.countdown_ended.connect(_handle_countdown_ended)


static func difficulty_name(diff: Difficulty) -> String:
	if diff == Difficulty.EASY:
		return "EASY"
	elif diff == Difficulty.MEDIUM:
		return "MEDIUM"
	elif diff == Difficulty.HARD:
		return "HARD"
	
	return "UNKNOWN"


func set_difficulty(diff: Difficulty) -> void:
	_difficulty = diff


func get_payout(wager: int, difficulty: Difficulty) -> int:
	return 0


func _start() -> void:
	pass


func _win() -> void:
	pass


func _lose() -> void:
	pass


func _end() -> void:
	signal_bus.end_minigame.emit()


func _handle_countdown_ended() -> void:
	pass

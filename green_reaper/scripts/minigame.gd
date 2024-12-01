class_name Minigame
extends Node2D

enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
}
var _payout_multiplier: Dictionary = {
	Difficulty.EASY: 1.25,
	Difficulty.MEDIUM: 1.5,
	Difficulty.HARD: 2.0
}
var _did_player_win: bool = false

var minigame_img_path: String
var minigame_scene_path: String
var minigame_name: String
var instructions: String

var _difficulty: Difficulty = Difficulty.HARD
@onready var countdown_label: CountdownLabel = $CountdownLabel
@onready var transition_timer: Timer = $TransitionTimer


func init() -> void:
	signal_bus.countdown_ended.connect(_handle_countdown_ended)
	transition_timer.timeout.connect(_handle_transition_timer_timeout)
	transition_timer.wait_time = 2.5
	transition_timer.one_shot = true


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
	return wager * _payout_multiplier[difficulty]


func _start() -> void:
	pass


func _win() -> void:
	_did_player_win = true
	transition_timer.start()


func _lose() -> void:
	_did_player_win = false
	transition_timer.start()


func _handle_countdown_ended() -> void:
	_start()


func _handle_transition_timer_timeout() -> void:
	pass

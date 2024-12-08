class_name Minigame
extends Node2D

enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
	# for boss/checkpoint minigame
	FINAL,
}
var _payout_multiplier: Dictionary = {
	Difficulty.EASY: 1.25,
	Difficulty.MEDIUM: 1.5,
	Difficulty.HARD: 2.0
}
var _did_player_win: bool = false
var _num_time_lucky: int = 0

var minigame_img_path: String
var minigame_scene_path: String
var minigame_name: String
var instructions: String
var tooltip_format: String
var easy_tooltip: String
var medium_tooltip: String
var hard_tooltip: String

var _difficulty: Difficulty = Difficulty.HARD
@onready var countdown_label: CountdownLabel = $CountdownLabel
@onready var luck_label: LuckLabel = $LuckLabel
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
	elif diff == Difficulty.FINAL:
		return "FINAL"
	
	return "UNKNOWN"


func set_difficulty(diff: Difficulty) -> void:
	_difficulty = diff


func get_payout(wager: int, difficulty: Difficulty) -> int:
	return wager * _payout_multiplier[difficulty]


func is_player_lucky() -> bool:
	if _num_time_lucky == 1:
		return false
	
	var is_lucky: bool = randf_range(0.0, 1.0) < state_manager.luck
	if is_lucky:
		_num_time_lucky += 1
	
	return is_lucky

func _start() -> void:
	pass


func _win() -> void:
	sfx_player.stop()
	sfx_player.play_shadowing()
	_did_player_win = true
	transition_timer.start()


func _lose() -> void:
	sfx_player.stop()
	sfx_player.play_every_step()
	_did_player_win = false
	transition_timer.start()


func _handle_countdown_ended() -> void:
	_start()


func _handle_transition_timer_timeout() -> void:
	pass

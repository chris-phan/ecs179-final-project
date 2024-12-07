class_name MemoryMinigame
extends Minigame

const _difficulty_rounds: Dictionary = {
	Difficulty.EASY: 7,
	Difficulty.MEDIUM: 10,
	Difficulty.HARD: 15,
}
var num_questions: int

var _player_choices: Array[MemoryObject.Colors]
var _sequence: Array[MemoryObject.Colors]
var _cur_round = 0
@onready var player: PlatformingPlayer = $Player
@onready var question_label: MemoryQuestionLabel = $MemoryQuestionLabel
@onready var memory_choices: MemoryChoices = $MemoryChoices
@onready var memory_history: MemoryHistory = $MemoryHistory


func _init() -> void:
	minigame_img_path = "res://assets/minigame_images/memory_minigame_img.png"
	minigame_scene_path = "res://scenes/memory_minigame.tscn"
	minigame_name = "Memory"
	instructions = "You're given a new color each round. Remember the previous colors and repeat the sequence by kicking the correct hearts."
	tooltip_format = "There are %d rounds."
	easy_tooltip = tooltip_format % [_difficulty_rounds[Difficulty.EASY]]
	medium_tooltip = tooltip_format % [_difficulty_rounds[Difficulty.MEDIUM]]
	hard_tooltip = tooltip_format % [_difficulty_rounds[Difficulty.HARD]]
	
	_payout_multiplier = {
		Difficulty.EASY: 1.5,
		Difficulty.MEDIUM: 2.0,
		Difficulty.HARD: 5.0
	}


func _ready() -> void:
	super.init()
	signal_bus.hit_memory_object.connect(_handle_hit_memory_object)
	countdown_label.start()
	memory_choices.disable()


func set_difficulty(diff: Difficulty) -> void:
	super.set_difficulty(diff)
	num_questions = _difficulty_rounds[diff]


func get_payout(wager: int, difficulty: Difficulty) -> int:
	return wager * _payout_multiplier[difficulty]


func _handle_countdown_ended() -> void:
	_start()


func _start() -> void:
	memory_choices.enable()
	_next_round()


func _next_round() -> void:
	_sequence.append(MemoryObject.Colors.values().pick_random())
	question_label.display(_sequence[-1])
	memory_history.clear()
	_player_choices.clear()
	_cur_round += 1


func _win() -> void:
	super._win()
	player.win()
	player.unbind_commands()
	print(_did_player_win)


func _lose() -> void:
	super._lose()
	player.lose()
	player.unbind_commands()


func _handle_hit_memory_object(color: MemoryObject.Colors) -> void:
	memory_history.show_next(color)
	_player_choices.append(color)
	
	var is_correct: bool = _is_selection_correct()
	if not is_correct:
		_lose()
	else:
		if len(_player_choices) == len(_sequence):
			if _cur_round == num_questions:
				_win()
			else:
				sfx_player.play_countdown()
				_next_round()
		else:
			sfx_player.play_correct_memory()


func _is_selection_correct() -> bool:
	for i in range(len(_player_choices)):
		if _player_choices[i] != _sequence[i]:
			return false
	return true


func _handle_transition_timer_timeout() -> void:
	signal_bus.end_minigame.emit(_did_player_win)

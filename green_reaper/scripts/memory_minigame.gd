class_name MemoryMinigame
extends Minigame

var num_questions: int = 5

var _player_choices: Array[MemoryObject.Colors]
var _sequence: Array[MemoryObject.Colors]
var _cur_round = 0

@onready var player: PlatformingPlayer = $Player
@onready var question_label: MemoryQuestionLabel = $MemoryQuestionLabel
@onready var memory_history: MemoryHistory = $MemoryHistory


func _ready() -> void:
	super.init()
	signal_bus.hit_memory_object.connect(_handle_hit_memory_object)
	countdown_label.start()


func _handle_countdown_ended() -> void:
	_next_round()


func _next_round() -> void:
	_sequence.append(MemoryObject.Colors.values().pick_random())
	question_label.display(_sequence[-1])
	memory_history.clear()
	_player_choices.clear()
	_cur_round += 1


func _win() -> void:
	player.win()
	player.unbind_commands()


func _lose() -> void:
	player.lose()
	player.unbind_commands()


func _handle_hit_memory_object(color: MemoryObject.Colors) -> void:
	memory_history.show_next(color)
	_player_choices.append(color)
	
	var is_correct: bool = _is_selection_correct()
	if not is_correct:
		_lose()
	elif is_correct and len(_player_choices) == len(_sequence):
		if _cur_round == num_questions:
			_win()
		else:
			_next_round()


func _is_selection_correct() -> bool:
	for i in range(len(_player_choices)):
		if _player_choices[i] != _sequence[i]:
			return false
	return true

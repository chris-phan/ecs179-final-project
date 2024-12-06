class_name ObservationMinigame
extends Minigame

const _border_top_left: Vector2 = Vector2(-120, -63)
const _border_bot_right: Vector2 = Vector2(120, 25)
const _margin: float = 1.0
const _difficulty_rounds: Dictionary = {
	Difficulty.EASY: 1,
	Difficulty.MEDIUM: 2,
	Difficulty.HARD: 3,
}
const _NUM_TARGETS_INCREMENT: int = 2

@export var observation_buttons: Array[ObservationButton]

var _max_rounds: int
var _answer: int = 0
var _obs_target_scene: PackedScene = preload("res://scenes/observation_target.tscn")
var _targets: Dictionary = {
	ObservationTarget.Type.NORMAL: [],
	ObservationTarget.Type.HAT: [],
	ObservationTarget.Type.HORNED: [],
}
var _min_targets: int = 8
var _max_targets: int = 15
var _cur_round: int = 0

@onready var timer: Timer = $Timer
@onready var player: PlatformingPlayer = $Player
@onready var question_label: Label = $QuestionLabel


func _init() -> void:
	minigame_img_path = "res://assets/minigame_images/observation_minigame_img.png"
	minigame_scene_path = "res://scenes/observation_minigame.tscn"
	minigame_name = "Observation"
	instructions = "Count the objects that appear and answer the question."
	tooltip_format = "There are %d rounds."
	easy_tooltip = "There is 1 round."
	medium_tooltip = tooltip_format % [_difficulty_rounds[Difficulty.MEDIUM]]
	hard_tooltip = tooltip_format % [_difficulty_rounds[Difficulty.HARD]]
	
	_payout_multiplier = {
		Difficulty.EASY: 1.25,
		Difficulty.MEDIUM: 1.5,
		Difficulty.HARD: 2.0
	}


func _ready() -> void:
	super.init()
	_difficulty = Difficulty.HARD
	signal_bus.hit_observation_button.connect(_handle_hit_observation_button)
	timer.timeout.connect(_handle_timeout)
	question_label.hide()
	_hide_buttons()
	countdown_label.start()


static func pick_rand_position(width: int) -> Vector2:
	# Picks a random position for observation targets
	# Observation targets' positions is their top left corner
	var top_left: Vector2 = _border_top_left
	var bot_right: Vector2 = _border_bot_right
	
	var pos_x: float = randf_range(bot_right.x - width - _margin, top_left.x + _margin)
	var pos_y: float = randf_range(top_left.y + _margin, bot_right.y - width - _margin)
	
	return Vector2(pos_x, pos_y)


func set_difficulty(diff: Difficulty) -> void:
	super.set_difficulty(diff)
	_max_rounds = _difficulty_rounds[diff]


func get_payout(wager: int, difficulty: Difficulty) -> int:
	return wager * _payout_multiplier[difficulty]


func _next_round() -> void:
	question_label.hide()
	timer.start()
	_generate_targets()
	_cur_round += 1
	_min_targets += _NUM_TARGETS_INCREMENT
	_max_targets += _NUM_TARGETS_INCREMENT


func _start() -> void:
	_next_round()


func _win() -> void:
	super._win()
	player.unbind_commands()
	player.win()


func _lose() -> void:
	super._lose()
	player.unbind_commands()
	player.lose()


func _generate_rand_num_targets() -> int:
	return randi_range(_min_targets, _max_targets)


# Round 0:  1 possible target
# Round 1:  2 possible targets
# Round 2+: 3 possible targets
func _set_target_type(target: ObservationTarget) -> ObservationTarget:
	var possibilities: Array[ObservationTarget.Type] = [ObservationTarget.Type.NORMAL]
	if _cur_round >= 1:
		possibilities.append(ObservationTarget.Type.HAT)
	if _cur_round >= 2:
		possibilities.append(ObservationTarget.Type.HORNED)
	
	target.set_type(possibilities.pick_random())
	return target


func _pick_valid_nonzero_target_type() -> ObservationTarget.Type:
	var possibilities: Array[ObservationTarget.Type] = []
	if _cur_round >= 0 and len(_targets[ObservationTarget.Type.NORMAL]) > 0:
		possibilities.append(ObservationTarget.Type.NORMAL)
	if _cur_round == 1 and len(_targets[ObservationTarget.Type.HAT]) > 0:
		possibilities.append(ObservationTarget.Type.HAT)
	if _cur_round >= 2 and len(_targets[ObservationTarget.Type.HORNED]) > 0:
		possibilities.append(ObservationTarget.Type.HORNED)
	
	return possibilities.pick_random()


func _generate_targets() -> void:
	var num_targets: int = _generate_rand_num_targets()
	for i in range(num_targets):
		var target: ObservationTarget = _obs_target_scene.instantiate() as ObservationTarget
		target = _set_target_type(target)
		call_deferred("add_child", target)
		_targets[target.get_type()].append(target)


func _set_buttons() -> void:
	var options: Array[int] = [_answer]
	var upper_bound = ceil(_answer * 1.5)
	var lower_bound = floor(_answer * 0.5)
	if upper_bound - lower_bound + 1 < 4:
		upper_bound = 10
		lower_bound = 1
	
	for i in range(len(observation_buttons)):
		var choice = randi_range(lower_bound, upper_bound)
		while choice in options:
			choice = randi_range(lower_bound, upper_bound)
		options.append(choice)
	
	options.sort()
	for i in range(len(observation_buttons)):
		observation_buttons[i].set_val(options[i])


func _hide_buttons() -> void:
	for btn in observation_buttons:
		btn.hide()


func _show_buttons() -> void:
	for btn in observation_buttons:
		btn.show()


func _delete_targets() -> void:
	for k in _targets.keys():
		for target in _targets[k]:
			target.queue_free()
	_targets = {
		ObservationTarget.Type.NORMAL: [],
		ObservationTarget.Type.HAT: [],
		ObservationTarget.Type.HORNED: [],
	}


func _handle_countdown_ended() -> void:
	_start()


func _handle_hit_observation_button(val: int) -> void:
	if val == _answer:
		_hide_buttons()
		if _cur_round < _max_rounds:
			_next_round()
		else:
			_win()
	else:
		_lose()


func _handle_timeout() -> void:
	var selected_type: ObservationTarget.Type = _pick_valid_nonzero_target_type()
	_answer = len(_targets[selected_type])
	print(_answer)
	print(_targets)
	_set_buttons()
	_show_buttons()
	_delete_targets()
	question_label.display(selected_type)


func _handle_transition_timer_timeout() -> void:
	signal_bus.end_minigame.emit(_did_player_win)

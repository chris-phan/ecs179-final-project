class_name Event
extends Node2D

var event_name: String
var event_body: String

var _cur_step: int
var _max_step: int

var op_1_text: String
var op_2_text: String

var op_1_visible: bool = true
var op_2_visible: bool = true
var ok_visible: bool = false

var _payout: int
var _luck_diff: float

var _min: float
var _max: float
var _stake_proportion: float
var _random_stake: int

func _init() -> void:
	_cur_step = 0

func start() -> void:
	_random_stake = _get_random_stake()
	_stake_proportion = (float)(_random_stake) / state_manager.cash


# Return random int from [min * cur_balance, max * cur_balance] (rounded to nearest 100)
func _get_random_stake() -> int:
	var cur_balance: int = state_manager.cash
	print("cur_balance = " + str(cur_balance))

	var _random_proportion: float = randf_range(_min, _max)
	var random_stake: float = _random_proportion * cur_balance
	var rounded_stake: int = round(random_stake / 100) * 100

	if rounded_stake < cur_balance:
		return rounded_stake

	# Don't round to nearest hundred if doing so causes stake to exceed balance
	return round(random_stake)


func get_payout() -> int:
	return _payout


func get_luck_diff() -> float:
	return _luck_diff


func select_option(option_num: int) -> void:
	pass


func _inc_step() -> void:
	_cur_step += 1
	if _cur_step == _max_step:
		_switch_buttons()


func _switch_buttons() -> void:
	op_1_visible = false
	op_2_visible = false
	ok_visible = true


func _get_stake_proportion() -> float:
	return _stake_proportion


# Called after "OK!" is pressed
func end_event() -> void:
	signal_bus.end_event.emit()

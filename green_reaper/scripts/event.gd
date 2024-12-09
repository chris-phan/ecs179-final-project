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

var _cur_balance: int
var _payout: int
var _random_stake: int

func _init(cur_balance: int) -> void:
	_cur_step = 0
	_cur_balance = cur_balance
	_random_stake = _get_random_stake()

# Return random int from [0.2 * cur_balance, 0.5 * cur_balance] (rounded to nearest 100)
func _get_random_stake() -> int:
	var min_stake: float = 0.2 * _cur_balance
	var max_stake: float = 0.5 * _cur_balance

	var random_stake: float = randf_range(min_stake, max_stake)
	var rounded_stake: int = round(random_stake / 100) * 100

	if rounded_stake < _cur_balance:
		return rounded_stake
	
	# Don't round to nearest hundred if doing so causes stake to exceed balance
	return round(random_stake)

func get_payout() -> int:
	return _payout

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

# Called after "OK!" is pressed
func end_event() -> void:
	signal_bus.end_event.emit()

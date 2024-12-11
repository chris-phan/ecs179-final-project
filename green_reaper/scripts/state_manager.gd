class_name StateManager
extends Node

var cash: int = 50000
var luck: float = 0.0
var turns_passed: int = 0

var _luck_sources: Array[float] = []
var board_exists: bool = true

func _ready() -> void:
	luck = _calc_luck()


func reset_player() -> void:
	cash = 50000
	luck = 0.0
	turns_passed = 0


func inc_luck(val: float) -> float:
	_luck_sources.append(val)
	luck = _calc_luck()
	return luck


func dec_luck(val: float) -> float:
	while len(_luck_sources) > 0:
		if val > _luck_sources[len(_luck_sources) - 1]:
			val -= _luck_sources[len(_luck_sources) - 1]
			_luck_sources.pop_back()
		else:
			_luck_sources[len(_luck_sources) - 1] -= val
			val = 0
			break
	
	if val > 0:
		luck = 0
	else:
		luck = _calc_luck()
	return luck


func _calc_luck() -> float:
	var prod: float = 1
	for i in range(len(_luck_sources)):
		prod *= (1 - _luck_sources[i])
	
	return 1 - prod

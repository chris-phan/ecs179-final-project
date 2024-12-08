class_name StateManager
extends Node

var cash: int = 50000
var luck: float = 0.0
var turns_passed: int = 0

var _luck_sources: Array[float] = []


func inc_luck(val: float) -> float:
	_luck_sources.append(val)
	luck = _calc_luck()
	return luck


func _calc_luck() -> float:
	var prod: float = 1
	for i in range(len(_luck_sources)):
		prod *= (1 - _luck_sources[i])
	
	return 1 - prod

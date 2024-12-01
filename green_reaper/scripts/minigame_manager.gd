class_name MinigameManager
extends Node2D

const WAGER_INC: int = 1000
var all_minigames: Array[Minigame]
var minigame_rotation: Array[Minigame]
var cur_minigame: Minigame
var cur_scene: Node

var minigame_name: String
var instructions: String
var difficulty: Minigame.Difficulty
var old_balance: int
var new_balance: int
var wager: int
var payout: int
var won: bool


func _ready() -> void:
	signal_bus.start_minigame.connect(_handle_start_minigame)
	signal_bus.end_minigame.connect(_handle_end_minigame)
	signal_bus.exit_minigame.connect(_handle_exit_minigame)
	
	var packed_scene = load("res://scenes/minigame_ui.tscn")
	cur_scene = packed_scene.instantiate() as MinigameUI
	cur_scene.set_minigame_manager(self)
	cur_scene.global_position = Vector2(0.0, 0.0)
	add_child(cur_scene)
	cur_minigame = TimePlatforming.new()
	
	minigame_name = cur_minigame.minigame_name
	instructions = cur_minigame.instructions
	cur_scene.set_labels()
	
	old_balance = 50000
	#minigame_rotation = all_minigames.duplicate()
	#minigame_rotation.shuffle()


func play() -> void:
	if len(minigame_rotation) == 0:
		minigame_rotation = all_minigames.duplicate()
		minigame_rotation.shuffle()
	
	cur_minigame = minigame_rotation.pop_back()


func increase_wager() -> int:
	wager = min(wager + WAGER_INC, old_balance)
	return wager


func decrease_wager() -> int:
	wager = max(wager - WAGER_INC, 0)
	return wager


func get_payout() -> int:
	payout = cur_minigame.get_payout(wager, difficulty)
	return payout


func _handle_start_minigame() -> void:
	remove_child(cur_scene)
	cur_scene = load("res://scenes/platforming_minigame.tscn").instantiate() as Minigame
	add_child(cur_scene)
	cur_scene.set_difficulty(difficulty)


func _handle_end_minigame(did_player_win: bool) -> void:
	remove_child(cur_scene)
	cur_scene = load("res://scenes/minigame_result_ui.tscn").instantiate() as MinigameResultUI
	add_child(cur_scene)
	cur_scene.global_position = Vector2(0.0, 0.0)
	won = did_player_win
	
	if won:
		new_balance = old_balance + (payout - wager)
	else:
		new_balance = old_balance - wager
	
	cur_scene.set_minigame_manager(self)
	cur_scene.set_labels()

func _handle_exit_minigame() -> void:
	pass

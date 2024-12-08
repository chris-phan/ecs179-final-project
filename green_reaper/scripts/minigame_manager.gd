class_name MinigameManager
extends Node2D

const WAGER_INC: int = 1000
var all_minigames: Array[Minigame]
var minigame_rotation: Array[Minigame]
var cur_minigame: Minigame
var cur_scene: Node

var minigame_img_path: String
var minigame_scene_path: String
var minigame_name: String
var instructions: String
var difficulty: Minigame.Difficulty
var easy_tooltip: String
var medium_tooltip: String
var hard_tooltip: String
var old_balance: int
var new_balance: int
var wager: int
var payout: int
var won: bool


func _ready() -> void:
	signal_bus.enter_minigame.connect(_handle_enter_minigame)
	signal_bus.start_minigame.connect(_handle_start_minigame)
	signal_bus.end_minigame.connect(_handle_end_minigame)
	signal_bus.exit_minigame.connect(_handle_exit_minigame)
	
	minigame_rotation.append(TimePlatformingMinigame.new())
	minigame_rotation.append(MemoryMinigame.new())
	minigame_rotation.append(InternalTimerMinigame.new())
	minigame_rotation.append(ObservationMinigame.new())
	
	old_balance = 50000
	minigame_rotation.shuffle()


func increase_wager() -> int:
	wager = min(wager + WAGER_INC, old_balance)
	return wager


func decrease_wager() -> int:
	wager = max(wager - WAGER_INC, 0)
	return wager


func get_payout() -> int:
	payout = cur_minigame.get_payout(wager, difficulty)
	return payout


func _handle_enter_minigame() -> void:
	show()
	difficulty = Minigame.Difficulty.EASY
	wager = 0
	won = false
	sfx_player.play_sunday_drive()
	
	var packed_scene = load("res://scenes/minigame_ui.tscn")
	cur_scene = packed_scene.instantiate() as MinigameUI
	cur_scene.set_minigame_manager(self)
	cur_scene.global_position = Vector2(0.0, 0.0)
	add_child(cur_scene)
	
	if len(minigame_rotation) == 0:
		minigame_rotation.append(TimePlatformingMinigame.new())
		minigame_rotation.append(MemoryMinigame.new())
		minigame_rotation.append(InternalTimerMinigame.new())
		minigame_rotation.append(ObservationMinigame.new())
		minigame_rotation.shuffle()
	
	cur_minigame = minigame_rotation.pop_back()
	minigame_img_path = cur_minigame.minigame_img_path
	minigame_scene_path = cur_minigame.minigame_scene_path
	minigame_name = cur_minigame.minigame_name
	instructions = cur_minigame.instructions
	easy_tooltip = cur_minigame.easy_tooltip
	medium_tooltip = cur_minigame.medium_tooltip
	hard_tooltip = cur_minigame.hard_tooltip
	cur_scene.set_labels()


func _handle_start_minigame() -> void:
	cur_scene.queue_free()
	cur_scene = load(minigame_scene_path).instantiate() as Minigame
	add_child(cur_scene)
	cur_scene.set_difficulty(difficulty)


func _handle_end_minigame(did_player_win: bool) -> void:
	cur_scene.queue_free()
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
	cur_scene.queue_free()
	hide()

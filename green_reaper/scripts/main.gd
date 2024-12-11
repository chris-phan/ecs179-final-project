class_name GameManager
extends Node2D

@onready var intro: Intro = $Intro
@onready var board: Board = $Board
@onready var minigame_manager: MinigameManager = $MinigameManager
@onready var event_manager: EventManager = $EventManager

const BOARD: PackedScene = preload("res://scenes/board.tscn")
const EVENT_MANAGER: PackedScene = preload("res://scenes/event_manager.tscn")
const MINIGAME_MANAGER: PackedScene = preload("res://scenes/minigame_manager.tscn")

var endgame_signaled: bool = false


func _ready() -> void:
	signal_bus.enter_minigame.connect(_handle_enter_minigame)
	signal_bus.exit_minigame.connect(_handle_exit_minigame)
	signal_bus.intro_done.connect(_handle_intro_done)
	signal_bus.enter_event.connect(_handle_enter_event)
	signal_bus.exit_event.connect(_handle_exit_event)
	signal_bus.reset_game.connect(_handle_reset_game)
	signal_bus.endgame_signal_received.connect(_set_endgame_signaled)

	sfx_player.play_board_bgm()
	board.hide()


func _process(delta: float) -> void:
	if (not endgame_signaled) and (state_manager.cash <= 0):
		signal_bus.lose_game.emit()
	elif (not endgame_signaled) and (state_manager.cash >= 1000000):
		signal_bus.win_game.emit()


func _handle_reset_game() -> void:
	state_manager.reset_player()
	endgame_signaled = false

	minigame_manager = MINIGAME_MANAGER.instantiate()
	event_manager = EVENT_MANAGER.instantiate()
	board = BOARD.instantiate()
	
	add_child(minigame_manager)
	add_child(event_manager)
	add_child(board)
	board.reset_board_movement()
	sfx_player.stop()
	sfx_player.play_board_bgm()


func _set_endgame_signaled() -> void:
	endgame_signaled = true


func _handle_enter_minigame() -> void:
	sfx_player.stop()
	sfx_player.play_sunday_drive()
	if board in get_children():
		remove_child(board)
	minigame_manager.show()


func _handle_exit_minigame() -> void:
	sfx_player.stop()
	sfx_player.play_board_bgm()
	minigame_manager.hide()
	add_child(board)


func _handle_intro_done() -> void:
	board.show()


func _handle_enter_event() -> void:
	sfx_player.stop()
	sfx_player.play_sunday_drive()
	remove_child(board)
	event_manager.show()


func _handle_exit_event() -> void:
	event_manager.hide()
	minigame_manager.show()

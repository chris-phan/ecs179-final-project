class_name GameManager
extends Node2D

@onready var board: Board = $Board
@onready var minigame_manager: MinigameManager = $MinigameManager


func _ready() -> void:
	signal_bus.enter_minigame.connect(_handle_enter_minigame)
	signal_bus.exit_minigame.connect(_handle_exit_minigame)
	sfx_player.play_board_bgm()


func _handle_enter_minigame() -> void:
	sfx_player.stop()
	sfx_player.play_sunday_drive()
	remove_child(board)
	minigame_manager.show()


func _handle_exit_minigame() -> void:
	sfx_player.stop()
	sfx_player.play_board_bgm()
	minigame_manager.hide()
	add_child(board)

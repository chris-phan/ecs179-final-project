class_name GameManager
extends Node2D

@onready var board: Board = $Board
@onready var minigame_manager: MinigameManager = $MinigameManager
@onready var event_manager: EventManager = $EventManager


func _ready() -> void:
	signal_bus.enter_minigame.connect(_handle_enter_minigame)
	signal_bus.exit_minigame.connect(_handle_exit_minigame)
	signal_bus.enter_event.connect(_handle_enter_event)
	signal_bus.exit_event.connect(_handle_exit_event)
	sfx_player.play_board_bgm()


func _process(delta: float) -> void:
	
	if state_manager.cash <= 0:
		pass
		#print("Lost game")
		
		# emit lose signal
		## show lose scene
	elif state_manager.cash >= 1000000:
		pass
		#print("won game")
		
		# emit win signal
		## show win scene


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


func _handle_enter_event() -> void:
	sfx_player.stop()
	sfx_player.play_sunday_drive()
	remove_child(board)
	event_manager.show()


func _handle_exit_event() -> void:
	sfx_player.stop()
	sfx_player.play_board_bgm()
	event_manager.hide()
	add_child(board)

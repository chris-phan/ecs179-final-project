class_name GameManager
extends Node2D

@onready var board: Board = $Board
@onready var minigame_manager: MinigameManager = $MinigameManager


func _ready() -> void:
	signal_bus.enter_minigame.connect(_handle_enter_minigame)
	signal_bus.exit_minigame.connect(_handle_exit_minigame)


func _process(delta: float) -> void:
	
	if state_manager.cash <= 0:
		print("Lost game")
		
		# emit lose signal
		## show lose scene
	elif state_manager.cash >= 1000000:
		print("won game")
		
		# emit win signal
		## show win scene


func _handle_enter_minigame() -> void:
	remove_child(board)
	minigame_manager.show()


func _handle_exit_minigame() -> void:
	minigame_manager.hide()
	add_child(board)

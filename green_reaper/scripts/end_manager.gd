class_name End
extends Control

@onready var win: Control = $Win
@onready var lose: Control = $Lose
@onready var end_camera: Camera2D = $EndCamera
@onready var end_dialogue: Label = $EndDialogue
@onready var end_reaper: AnimatedSprite2D = $EndReaper
@onready var end_player: AnimatedSprite2D = $EndPlayer
@onready var restart_panel: Panel = $RestartPanel
@onready var restart_game_button: Button = $RestartPanel/RestartGameButton

var outside_game: bool = false
var start_dialogue: bool = false
var won_game: bool = false
var start_animation: bool = false


func _ready() -> void:
	signal_bus.win_game.connect(_handle_win_game)
	signal_bus.lose_game.connect(_handle_lose_game)
	
	signal_bus.enter_minigame.connect(_set_false_outside_game)
	signal_bus.exit_minigame.connect(_set_true_outside_game)
	
	signal_bus.enter_event.connect(_set_false_outside_game)
	signal_bus.exit_event.connect(_set_false_outside_game)
	
	signal_bus.space_ended_game.connect(_set_true_outside_game)
	
	restart_game_button.button_up.connect(reset_game)
	
	visible = false
	end_camera.enabled = false
	end_dialogue.visible_ratio = 0.0


func _process(delta: float) -> void:
	
	if start_dialogue:
		end_dialogue.visible_ratio += delta / 5
		if end_dialogue.visible_ratio >= 1.0:
			start_dialogue = false
			_begin_animations()
	
	if start_animation:
		if won_game:
			end_player.position.y += delta * 20
			
		else:
			end_player.position.x += delta * 20
			end_reaper.position.x += delta * 20


func _begin_animations() -> void:
	start_animation = true
	
	if won_game:
		end_player.play("down")
		end_reaper.play("walking")
	else:
		end_player.play("right")
		end_reaper.position = end_player.position
		end_reaper.position.x += 20
		end_reaper.play("walking")


func _handle_win_game() -> void:
	
	if outside_game:
		_set_sprite_positions()
		visible = true
		win.visible = true
		lose.visible = false
		end_camera.enabled = true
		end_camera.position = Vector2(0,0)
		won_game = true
			
		end_dialogue.text = "Wow! You actually did it! Very well, enjoy your extended life... Maybe we'll meet again in the future."
		if state_manager.turns_passed == 1:
			end_dialogue.text += "\n\nTime: 1 day"
		else:
			end_dialogue.text += "\nTime: " + str(state_manager.turns_passed) + " days"
		end_dialogue.text += "\nLuck: %.2f%%" % [state_manager.luck * 100]
		end_dialogue.text += "\nCash: $" + str(state_manager.cash)
		end_dialogue.visible_ratio = 0.0
		start_dialogue = true
		signal_bus.endgame_signal_received.emit()


func _handle_lose_game() -> void:
	if outside_game:
		_set_sprite_positions()
		visible = true
		win.visible = false
		lose.visible = true
		end_camera.enabled = true
		end_camera.position = Vector2(0,0)
		won_game = false
	
		end_dialogue.text = "Oh well, at least you tried! I guess it's afterlife time... Come with me, I'll take ya there!"
		if state_manager.turns_passed == 1:
			end_dialogue.text += "\n\nTime: 1 day"
		else:
			end_dialogue.text += "\nTime: " + str(state_manager.turns_passed) + " days"
		end_dialogue.text += "\nLuck: %.2f%%" % [state_manager.luck * 100]
		end_dialogue.text += "\nCash: $" + str(state_manager.cash)
		end_dialogue.visible_ratio = 0.0
		start_dialogue = true
		signal_bus.endgame_signal_received.emit()


func _set_sprite_positions() -> void:
	start_animation = false
	end_player.play("idle")	
	end_reaper.position = Vector2(386, -165)
	end_player.position = Vector2(-319, 118)


func _set_false_outside_game() -> void:
	outside_game = false


func _set_true_outside_game() -> void:
	outside_game = true


func reset_game() -> void:
	visible = false
	start_dialogue = false
	_set_sprite_positions()
	end_camera.enabled = false
	signal_bus.reset_game.emit()

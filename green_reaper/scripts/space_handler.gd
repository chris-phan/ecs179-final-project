extends Node2D

@export var animation_duration: float = 2.5
@export var transition_duration: float = 2.0
@export var transition_rate: float = 25.0

@onready var board_player: CharacterBody2D = %BoardPlayer
@onready var _animated_space: AnimatedSprite2D = $AnimatedSpace
@onready var random_positive_value_label: Label = $"../RandomPositiveValueLabel"
@onready var random_negative_value_label: Label = $"../RandomNegativeValueLabel"

const VALID_SPACE_NAMES: Array[String] = ["event", "gain_money", "gain_luck", "lose_money", "lose_luck"]
const MULTIPLIER_VALUES: Array[float] = [0.02, 0.04, 0.06, 0.08, 0.10, 0.12, 0.14, 0.16, 0.18, 0.20]

var _animation_timer: Timer
var _transition_animation_timer: Timer
var _x_toggle: int = 1
var _space_name: String

signal event_space_landed
signal animation_done


func _ready() -> void:
	visible = false
	random_positive_value_label.visible = false
	random_negative_value_label.visible = false
	_space_name = ""
	
	board_player.connect("space_landed", handle_space)


func _process(delta: float) -> void:
	if (_animation_timer != null) and (_animation_timer.time_left > 0):
		# space flare
		if _space_name.find("gain") != -1:
			if position.y < board_player.position.y - 20:
				position.y = board_player.position.y
				position.x = board_player.position.x + (20 * _x_toggle)
				_x_toggle *= -1
			else:
				position.y -= delta * 100
		else:
			if position.y > board_player.position.y:
				position.y = board_player.position.y - 20
				position.x = board_player.position.x + (20 * _x_toggle)
				_x_toggle *= -1
			else:
				position.y += delta * 100
		
		# value label
		random_negative_value_label.position.y += delta * 20
		random_positive_value_label.position.y -= delta * 20
	
	if (_transition_animation_timer != null) and (_transition_animation_timer.time_left > 0):
		scale += Vector2(transition_rate, transition_rate) * delta


func handle_space(space_name: String) -> void:
	_space_name = space_name
	
	if space_name not in VALID_SPACE_NAMES:
		print("Invalid space received")
	else:
		if (space_name == "event"):
			position.x = board_player.position.x + (20 * _x_toggle)
			position.y = board_player.position.y
			
			visible = true
			
			position = board_player.position
			position.y += 40
			_transition_animation_timer = Timer.new()
			add_child(_transition_animation_timer)
			_animated_space.play("transition")
			_transition_animation_timer.wait_time = transition_duration
			_transition_animation_timer.one_shot = true
			_transition_animation_timer.start()
			
			await _transition_animation_timer.timeout
			visible = false
			scale = Vector2(1, 1)
			
			signal_bus.enter_event.emit()
		else:
			position.x = board_player.position.x + (20 * _x_toggle)
			position.y = board_player.position.y
			
			visible = true
			_animation_timer = Timer.new()
			add_child(_animation_timer)
			_animated_space.play(space_name)
			_animation_timer.wait_time = animation_duration
			_animation_timer.one_shot = true
			_animation_timer.start()
			
			var money_value: int = 0
			
			if (space_name == "gain_money"):
				money_value = handle_gain_money()
			elif (space_name == "gain_luck"):
				handle_gain_luck()
			elif (space_name == "lose_money"):
				money_value = handle_lose_money()
			elif (space_name == "lose_luck"):
				handle_lose_luck()
			else:
				print("error in space handler")
			
			await _animation_timer.timeout
			random_positive_value_label.visible = false
			random_negative_value_label.visible = false
			
			if (space_name == "gain_money"):
				state_manager.cash += money_value
			elif (space_name == "lose_money"):
				state_manager.cash -= money_value


			if (state_manager.cash > 0 and state_manager.cash < 1000000):
				position = board_player.position
				position.y += 40
				_transition_animation_timer = Timer.new()
				add_child(_transition_animation_timer)
				_animated_space.play("transition")
				_transition_animation_timer.wait_time = transition_duration
				_transition_animation_timer.one_shot = true
				_transition_animation_timer.start()
				
				await _transition_animation_timer.timeout
				visible = false
				scale = Vector2(1, 1)
				
				signal_bus.enter_minigame.emit()
			else:
				signal_bus.space_ended_game.emit()


func handle_gain_money() -> int:
	sfx_player.play_board_positive()
	# increment money in player manager
	var value: int = state_manager.cash * MULTIPLIER_VALUES[randf_range(0, len(MULTIPLIER_VALUES) - 1)]
	print("adding " + str(value))
	show_positive_value("$" + str(value))
	return value


func handle_gain_luck() -> void:
	sfx_player.play_board_positive()
	# increment luck in player manager
	var value: float = MULTIPLIER_VALUES[randf_range(0, len(MULTIPLIER_VALUES) - 1)]
	print("adding " + str(value))
	state_manager.inc_luck(value)
	show_positive_value(str("%.0f" % [value * 100]) + "%")


func handle_lose_money() -> int:
	sfx_player.play_board_negative()
	# decrement money in player manager
	var value: int = state_manager.cash * MULTIPLIER_VALUES[randf_range(0, len(MULTIPLIER_VALUES) - 1)]
	if value == 0:
		value = 1
	print("subtracting " + str(value))
	show_negative_value("$" + str(value))
	return value


func handle_lose_luck() -> void:
	sfx_player.play_board_negative()
	# decrement luck in player manager
	var value: float = MULTIPLIER_VALUES[randf_range(0, len(MULTIPLIER_VALUES) - 1)]
	print("subtracting " + str(value))
	state_manager.dec_luck(value)
	show_negative_value(str("%.0f" % [value * 100]) + "%")


func show_positive_value(value: String) -> void:
	print("pos: " + value)
	random_positive_value_label.text = "+" + value
	random_positive_value_label.position = board_player.position
	random_positive_value_label.visible = true


func show_negative_value(value: String) -> void:
	print("neg: " + value)	
	random_negative_value_label.text = "-" + value
	random_negative_value_label.position = board_player.position
	random_negative_value_label.position.y -= 50
	random_negative_value_label.visible = true

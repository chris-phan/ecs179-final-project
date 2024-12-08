extends Node2D

@export var animation_duration: float = 2.5

@onready var board_player: CharacterBody2D = %BoardPlayer
@onready var _animated_space: AnimatedSprite2D = $AnimatedSpace

const VALID_SPACE_NAMES: Array[String] = ["event", "gain_money", "gain_luck", "lose_money", "lose_luck"]

var _animation_timer: Timer
var _x_toggle: int = 1

signal event_space_landed
signal animation_done


func _ready() -> void:
	visible = false
	board_player.connect("space_landed", handle_space)


func _process(delta: float) -> void:
	if (_animation_timer != null) and (_animation_timer.time_left > 0):
		if position.y < board_player.position.y - 20:
			position.y = board_player.position.y
			position.x = board_player.position.x + (20 * _x_toggle)
			_x_toggle *= -1
		else:
			position.y -= delta * 100


func handle_space(space_name: String) -> void:
	print("space deteced: " + space_name)
	
	if space_name not in VALID_SPACE_NAMES:
		print("Invalid space received")
	else:
		if (space_name == "event"):
			# signal event space landed
			emit_signal("event_space_landed")
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
			
			if (space_name == "gain_money"):
				handle_gain_money()
			elif (space_name == "gain_luck"):
				handle_gain_luck()
			elif (space_name == "lose_money"):
				handle_lose_money()
			elif (space_name == "lose_luck"):
				handle_lose_luck()
			else:
				print("error in space handler")
			
			await _animation_timer.timeout
			visible = false
			
			
			signal_bus.enter_minigame.emit()


func handle_gain_money() -> void:
	state_manager.cash += 1000
	# increment money in player manager

func handle_gain_luck() -> void:
	# increment luck in player manager
	state_manager.luck *= 1.1

func handle_lose_money() -> void:
	# decrement money in player manager
	state_manager.cash -= 1000

func handle_lose_luck() -> void:
	# decrement luck in player manager
	state_manager.luck *= 0.9

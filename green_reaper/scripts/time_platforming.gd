class_name TimePlatformingMinigame
extends Minigame

const _difficulty_times: Dictionary = {
	Difficulty.EASY: 15.0,
	Difficulty.MEDIUM: 12.0,
	Difficulty.HARD: 8.0,
}

var time_to_beat: float
@onready var player: PlatformingPlayer = $Player
@onready var goal: PlatformingGoal = $PlatformingGoal
@onready var game_timer: Timer = $GameTimer
@onready var timer_label: Label = $GameTimer/TimerLabel


func _init() -> void:
	minigame_img_path = "res://assets/minigame_images/time_platforming_game_img.png"
	minigame_scene_path = "res://scenes/time_platforming_minigame.tscn"
	minigame_name = "Time Platforming"
	instructions = "Get to the heart before time runs out."
	
	_payout_multiplier = {
		Difficulty.EASY: 1.25,
		Difficulty.MEDIUM: 1.5,
		Difficulty.HARD: 2.0
	}


func _ready() -> void:
	super.init()
	signal_bus.reached_platforming_goal.connect(_handle_reached_goal)
	
	game_timer.timeout.connect(_handle_game_timer_timeout)	
	transition_timer.timeout.connect(_handle_transition_timer_timeout)
	
	countdown_label.start()
	player.unbind_commands()


func _process(_delta: float) -> void:
	if not game_timer.is_stopped():
		timer_label.text = "%.2f" % [game_timer.time_left]


func get_payout(wager: int, difficulty: Difficulty) -> int:
	return int(wager * _payout_multiplier[difficulty])


func set_difficulty(diff: Difficulty) -> void:
	super.set_difficulty(diff)
	time_to_beat = _difficulty_times[diff]
	game_timer.wait_time = time_to_beat
	timer_label.text = "%.2f" % [time_to_beat]


func _win() -> void:
	super._win()
	player.unbind_commands()
	player.win()


func _lose() -> void:
	super._lose()
	player.unbind_commands()
	player.lose()


func _handle_reached_goal() -> void:
	var is_timer_stopped: bool = game_timer.is_stopped()
	game_timer.stop()
	
	if not is_timer_stopped:
		_win()
	else:
		_lose()
	
	signal_bus.reached_platforming_goal.disconnect(_handle_reached_goal)


func _handle_countdown_ended() -> void:
	player.bind_commands()
	game_timer.start()


func _handle_game_timer_timeout() -> void:
	_lose()
	timer_label.text = "%.2f" % [0]


func _handle_transition_timer_timeout() -> void:
	signal_bus.end_minigame.emit(_did_player_win)

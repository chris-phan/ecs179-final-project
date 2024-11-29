class_name TimePlatforming
extends Minigame

const _payout_multiplier: Dictionary = {
	Difficulty.EASY: 1.25,
	Difficulty.MEDIUM: 1.5,
	Difficulty.HARD: 2.0
}

var time_to_beat: float = 10.0

@onready var player: PlatformingPlayer = $Player
@onready var goal: PlatformingGoal = $PlatformingGoal
@onready var game_timer: Timer = $GameTimer


func _ready() -> void:
	super.init()
	signal_bus.reached_platforming_goal.connect(_handle_reached_goal)
	
	game_timer.timeout.connect(_handle_game_timeout)
	game_timer.wait_time = time_to_beat
	
	countdown_label.start()
	player.unbind_commands()


func _calculate_payout(base_bet: int, difficulty: Difficulty) -> int:
	return int(base_bet * _payout_multiplier[difficulty])


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


func _handle_game_timeout() -> void:
	_lose()


func _win() -> void:
	player.unbind_commands()
	player.win()
	
	# do some stuff here to help UI, i.e. some book keeping
	# e.g. calculate payout


func _lose() -> void:
	player.unbind_commands()
	player.lose()
	
	# do some stuff here to help UI, i.e. some book keeping
	# e.g. calculate payout

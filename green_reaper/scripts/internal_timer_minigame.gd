class_name InternalTimerMinigame
extends Minigame

const _timer_duration: float = 10.0
const _difficulty_tolerance: Dictionary = {
	Difficulty.EASY: 0.75,
	Difficulty.MEDIUM: 0.5,
	Difficulty.HARD: 0.15,
}

var _elapsed_overtime: float = 0.0
var _count_time: bool = false
var _tolerance: float
var _timed_out: bool = false
var _is_lucky: bool = false

@onready var stop_timer_object: StopTimerObject = $StopTimerObject
@onready var timer_label: Label = $TimerLabel
@onready var player: PlatformingPlayer = $Player
@onready var timer: Timer = $Timer


func _init() -> void:
	minigame_img_path = "res://assets/minigame_images/internal_timer_minigame_img.png"
	minigame_scene_path = "res://scenes/internal_timer_minigame.tscn"
	minigame_name = "Internal Timer"
	instructions = "Kick the chest to stop the timer as close to 0 as possible."
	tooltip_format = "You have %.2f seconds of leeway."
	easy_tooltip = tooltip_format % [_difficulty_tolerance[Difficulty.EASY]]
	medium_tooltip = tooltip_format % [_difficulty_tolerance[Difficulty.MEDIUM]]
	hard_tooltip = tooltip_format % [_difficulty_tolerance[Difficulty.HARD]]
	controls = [Controls.MOVE_LEFT, Controls.MOVE_RIGHT, Controls.KICK]
	
	_payout_multiplier = {
		Difficulty.EASY: 1.25,
		Difficulty.MEDIUM: 2.0,
		Difficulty.HARD: 3.0
	}


func _ready() -> void:
	super.init()
	signal_bus.hit_stop_timer_button.connect(_handle_stop_timer_button_hit)
	timer.timeout.connect(_handle_timer_timeout)
	timer.wait_time = _timer_duration
	timer.one_shot = true
	timer_label.text = "%.2f" % [_timer_duration]
	countdown_label.start()
	stop_timer_object.hide()
	
	_is_lucky = is_player_lucky()


func _process(delta: float) -> void:
	if _count_time:
		if timer.time_left < 7.50:
			if _is_lucky:
				timer_label.text = "%.2f" % [timer.time_left]
			else:
				timer_label.hide()
				sfx_player.stop_sunday_drive()
				sfx_player.play_heartbeat()
		else:
			timer_label.text = "%.2f" % [timer.time_left]
	if _timed_out:
		_elapsed_overtime += delta
		timer_label.text = "%.2f" % [-1 * _elapsed_overtime]


func set_difficulty(diff: Difficulty) -> void:
	super.set_difficulty(diff)
	_tolerance = _difficulty_tolerance[diff]


func get_payout(wager: int, difficulty: Difficulty) -> int:
	return wager * _payout_multiplier[difficulty]


func _handle_countdown_ended() -> void:
	_start()
	if _is_lucky:
		luck_label.display()


func _start() -> void:
	_count_time = true
	timer.start()
	stop_timer_object.show()


func _win() -> void:
	super._win()
	player.unbind_commands()
	player.win()


func _lose() -> void:
	super._lose()
	player.unbind_commands()
	player.lose()


func _handle_timer_timeout() -> void:
	_timed_out = true


func _handle_stop_timer_button_hit() -> void:
	sfx_player.stop_heartbeat()
	_count_time = false
	_timed_out = false
	if timer.is_stopped():
		timer_label.text = "-%.2f" % [_elapsed_overtime]
	else:
		timer_label.text = "%.2f" % [timer.time_left]
		timer.stop()
	timer_label.show()
	
	var time: float = float(timer_label.text)
	if abs(time) > _tolerance:
		_lose()
	else:
		_win()


func _handle_transition_timer_timeout() -> void:
	signal_bus.end_minigame.emit(_did_player_win)

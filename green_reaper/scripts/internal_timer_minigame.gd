class_name InternalTimerMinigame
extends Minigame

const _timer_duration: float = 10.0

var _elapsed_overtime: float = 0.0
var _count_time: bool = false

@onready var stop_timer_object: StopTimerObject = $StopTimerObject
@onready var timer_label: Label = $TimerLabel
@onready var timer: Timer = $Timer
 

func _ready() -> void:
	super.init()
	signal_bus.hit_stop_timer_button.connect(_handle_stop_timer_button_hit)
	timer.wait_time = _timer_duration
	timer.one_shot = true
	timer_label.text = "%.2f" % [_timer_duration]
	countdown_label.start()
	stop_timer_object.hide()


func _process(delta: float) -> void:
	if _count_time:
		if timer.time_left < 7.50:
			timer_label.hide()
		else:
			timer_label.text = "%.2f" % [timer.time_left]
	if timer.is_stopped():
		_elapsed_overtime += delta


func _handle_countdown_ended() -> void:
	_start()


func _start() -> void:
	_count_time = true
	timer.start()
	stop_timer_object.show()
	


func _handle_stop_timer_button_hit() -> void:
	_count_time = false
	if timer.is_stopped():
		timer_label.text = "-%.2f" % [_elapsed_overtime]
	else:
		timer_label.text = "%.2f" % [timer.time_left]
		timer.stop()
	timer_label.show()

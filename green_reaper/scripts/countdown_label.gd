class_name CountdownLabel
extends Label

@export var label_text: Array[String] = ["3", "2", "1", "GO!"]

var _idx: int = 0

@onready var countdown_timer = $CountdownTimer


func _ready() -> void:
	countdown_timer.timeout.connect(_handle_timeout)
	text = label_text[_idx]
	sfx_player.play_countdown()


func start() -> void:
	countdown_timer.start()


func _handle_timeout() -> void:
	_idx += 1
	if _idx >= len(label_text):
		signal_bus.countdown_ended.emit()
		queue_free()
	else:
		if _idx == len(label_text) - 1:
			sfx_player.play_countdown_go()
		else:
			sfx_player.play_countdown()
		
		text = label_text[_idx]
		countdown_timer.start()
	

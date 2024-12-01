class_name CountdownLabel
extends Label

@export var label_text: Array[String] = ["3", "2", "1", "GO!"]

var _idx: int = 0

@onready var countdown_timer = $CountdownTimer


func _ready() -> void:
	countdown_timer.timeout.connect(_handle_timeout)
	text = label_text[_idx]


func start() -> void:
	countdown_timer.start()


func _handle_timeout() -> void:
	_idx += 1
	if _idx >= len(label_text):
		signal_bus.countdown_ended.emit()
		queue_free()
	else:
		text = label_text[_idx]
		countdown_timer.start()

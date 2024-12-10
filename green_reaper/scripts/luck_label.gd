class_name LuckLabel
extends Label

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_handle_timeout)
	timer.one_shot = true
	timer.wait_time = 1.0
	hide()


func display() -> void:
	sfx_player.play_lucky()
	show()
	timer.start()


func _handle_timeout() -> void:
	hide()

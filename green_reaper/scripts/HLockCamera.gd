class_name HLockCamera
extends Camera2D

@export var target: PlatformingPlayer
const BOX_HEIGHT: int = 50
const TIMER_POS: Vector2 = Vector2(98, -75)
const COUNTDOWN_POS: Vector2 = Vector2(-45.5, -32.5)
const LUCK_POS: Vector2 = Vector2(-31.5, -81)
var _thresholds: Array[int] = [81, 153, 225]
var _lerping_to_player: bool = false
var _lerping_down: bool = false
@onready var timer_label: Label = %TimerLabel
@onready var countdown_label: CountdownLabel = %CountdownLabel
@onready var luck_label: LuckLabel = %LuckLabel

func _ready() -> void:
	countdown_label.position = Vector2(-45.5, -32.5)
	luck_label.position = LUCK_POS


func _physics_process(delta: float) -> void:
	var tpos: Vector2 = target.global_position
	var cpos: Vector2 = global_position
	
	if _lerping_to_player:
		_lerping_down = false
		global_position.y = lerpf(global_position.y, 9, delta * 3)
		_thresholds = [81, 153, 225]
	
	if tpos.y > cpos.y or _lerping_down:
		global_position.y = lerpf(global_position.y, global_position.y + 72, delta * 3)
		_lerping_down = true
		_lerping_to_player = false
		if len(_thresholds) == 0 or global_position.y > _thresholds[0]:
			_thresholds.pop_front()
			_lerping_down = false
	
	if len(_thresholds) == 0:
		var diff_between_bottom_edges = (tpos.y + 17 / 2.0) - (cpos.y + BOX_HEIGHT / 2.0)
		if diff_between_bottom_edges > 0:
			global_position.y += diff_between_bottom_edges + 5
	
	
	timer_label.position = TIMER_POS
	luck_label.position = LUCK_POS


func lerp_to_player() -> void:
	_lerping_to_player = true

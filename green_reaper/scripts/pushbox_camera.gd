class_name PushboxCamera
extends Camera2D

@export var target: PlatformingPlayer
const BOX_WIDTH: int = 40
const BOX_HEIGHT: int = 70
const TIMER_POS: Vector2 = Vector2(98, -75)
const COUNTDOWN_POS: Vector2 = Vector2(-45.5, -32.5)
const LUCK_POS: Vector2 = Vector2(-31.5, -81)
var _lerping_to_player: bool = false
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
		global_position.x = lerpf(cpos.x, -218.0, delta * 5)
		global_position.y = lerpf(cpos.y, 0.0, delta * 5)
		if global_position.x < tpos.x:
			_lerping_to_player = false
	else:
		# left
		var diff_between_left_edges = (tpos.x - 10 / 2.0) - (cpos.x - BOX_WIDTH / 2.0)
		if diff_between_left_edges < 0:
			global_position.x += diff_between_left_edges
		# right
		var diff_between_right_edges = (tpos.x + 10 / 2.0) - (cpos.x + BOX_WIDTH / 2.0)
		if diff_between_right_edges > 0:
			global_position.x += diff_between_right_edges
		# top
		var diff_between_top_edges = (tpos.y - 17 / 2.0) - (cpos.y - BOX_HEIGHT / 2.0)
		if diff_between_top_edges < 0:
			global_position.y += diff_between_top_edges
		# bottom
		var diff_between_bottom_edges = (tpos.y + 17 / 2.0) - (cpos.y + BOX_HEIGHT / 2.0)
		if diff_between_bottom_edges > 0:
			global_position.y += diff_between_bottom_edges
	
	global_position.y = max(-40.0, global_position.y)
	timer_label.position = TIMER_POS
	luck_label.position = LUCK_POS


func lerp_to_player() -> void:
	_lerping_to_player = true

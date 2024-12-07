class_name CameraBase
extends Camera2D

@export var zoom_out: float = 1.75
@export var zoom_in: float = 3.0
@export var zoom_out_move_speed: int = 250

const MAP_X_MAX = 512
const MAP_X_MIN = -512
const MAP_Y_MAX = -234
const MAP_Y_MIN = 345

var _board_player: CharacterBody2D
var _camera_on_player: bool = false
var _zoom_out_x: int
var _zoom_out_y: int


func _ready() -> void:
	_board_player = %BoardPlayer
	_zoom_out_x = _board_player.position.x
	_zoom_out_y = _board_player.position.y
	zoom_in_camera()


func _process(delta: float) -> void:
	# press 'z' key
	if Input.is_action_just_pressed("zoom_toggle"):
		if (not _camera_on_player):
			zoom_in_camera()
		else:
			zoom_out_camera()

	if (_camera_on_player):
		position = _board_player.position
	else:
		position = Vector2(_zoom_out_x, _zoom_out_y)
		
		if Input.is_action_pressed("map_up"):
			_zoom_out_y = max(MAP_Y_MAX, (_zoom_out_y - (delta * zoom_out_move_speed)))
		if Input.is_action_pressed("map_down"):
			_zoom_out_y = min(MAP_Y_MIN, (_zoom_out_y + (delta * zoom_out_move_speed)))
		if Input.is_action_pressed("map_right"):
			_zoom_out_x = min(MAP_X_MAX, (_zoom_out_x + (delta * zoom_out_move_speed)))
		if Input.is_action_pressed("map_left"):
			_zoom_out_x = max(MAP_X_MIN, (_zoom_out_x - (delta * zoom_out_move_speed)))


func zoom_in_camera() -> void:
	position = _board_player.position
	zoom = Vector2(zoom_in, zoom_in)
	_camera_on_player = true


func zoom_out_camera() -> void:
	_zoom_out_x = _board_player.position.x
	_zoom_out_y = _board_player.position.y
	zoom = Vector2(zoom_out, zoom_out)
	_camera_on_player = false
	

class_name CameraBase
extends Camera2D

@export var zoom_out: float = 1.75
@export var zoom_in: float = 3.0
@export var zoom_out_move_speed: int = 250

@onready var points_label: Label = $PointsLabel
@onready var luck_label: Label = $LuckLabel
@onready var turn_label: Label = $TurnLabel
@onready var dice: Node2D = $"../Dice"

const MAP_X_MAX = 512
const MAP_X_MIN = -512
const MAP_Y_MAX = -234
const MAP_Y_MIN = 345

const POINTS_VECTOR: Vector2 = Vector2(125, -105)
const LUCK_VECTOR: Vector2 = Vector2(125, -95)
const TURN_VECTOR: Vector2 = Vector2(-180, -105)

var _board_player: CharacterBody2D
var _camera_on_player: bool = false
var _zoom_out_x: int
var _zoom_out_y: int
var _disabled: bool = false


func _ready() -> void:
	_board_player = %BoardPlayer
	_zoom_out_x = _board_player.position.x
	_zoom_out_y = _board_player.position.y
	zoom_in_camera()


func _process(delta: float) -> void:
	if _disabled:
		return
	
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
	
	# scaling labels for zoom
	for label in get_children():
		if label is Label:
			label.scale = Vector2(1.5 / zoom.x, 1.5 / zoom.y)
			
			if (_camera_on_player):
				points_label.position = POINTS_VECTOR
				luck_label.position = LUCK_VECTOR
				turn_label.position = TURN_VECTOR
			else:
				points_label.position = POINTS_VECTOR * (zoom_in/zoom_out)
				luck_label.position = LUCK_VECTOR * (zoom_in/zoom_out)
				turn_label.position = TURN_VECTOR * (zoom_in/zoom_out)
	
	turn_label.text = "Turns Passsed: " + str(dice.times_rolled)
	points_label.text = "Points: " + str(dice.times_rolled) # add player manager obj and reference points
	luck_label.text = "Luck: " + str(dice.times_rolled) # add player manager obj and reference luck


func zoom_in_camera() -> void:
	position = _board_player.position
	zoom = Vector2(zoom_in, zoom_in)
	_camera_on_player = true


func zoom_out_camera() -> void:
	_zoom_out_x = _board_player.position.x
	_zoom_out_y = _board_player.position.y
	zoom = Vector2(zoom_out, zoom_out)
	_camera_on_player = false
	

func disable() -> void:
	_disabled = true


func enable() -> void:
	_disabled = false

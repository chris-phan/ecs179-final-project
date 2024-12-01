class_name CameraBase
extends Camera2D

@export var zoom_out: float = 2.5
@export var zoom_in: float = 5.0

var _board_player: CharacterBody2D
var _camera_on_player: bool = false


func _ready() -> void:
	_board_player = %BoardPlayer
	position = Vector2(0, 0)
	zoom = Vector2(zoom_out, zoom_out)


func _process(delta: float) -> void:
	# press 'z' key
	if Input.is_action_just_pressed("zoom_toggle"):
		if (not _camera_on_player):
			zoom = Vector2(zoom_in, zoom_in)
		else:
			zoom = Vector2(zoom_out, zoom_out)

		_camera_on_player = not _camera_on_player
	
	if (_camera_on_player):
		position = _board_player.position
	else:
		position = Vector2(0, 0)
	

class_name TimePlatformingMinigame2
extends TimePlatformingMinigame

@onready var camera: Camera2D = $Camera2D
var camera_width: int = 288
var camera_height: int = 162
var timer_pos: Vector2 = Vector2(98, -75)
@onready var killzone: Area2D = $Killzone


func _init() -> void:
	_difficulty_times = {
		Difficulty.EASY: 15.0,
		Difficulty.MEDIUM: 10.0,
		Difficulty.HARD: 7.5,
	}
	super._init()
	_payout_multiplier = {
		Difficulty.EASY: 1.25,
		Difficulty.MEDIUM: 2.0,
		Difficulty.HARD: 3.0
	}
	minigame_scene_path = "res://scenes/time_platforming_minigame2.tscn"
	minigame_img_path = "res://assets/minigame_images/time_platforming_game2_img.png"


func _ready() -> void:
	super._ready()
	killzone.body_entered.connect(_handle_body_entered)


func _handle_body_entered(_body: Node2D) -> void:
	player.global_position = Vector2(-233, 24)

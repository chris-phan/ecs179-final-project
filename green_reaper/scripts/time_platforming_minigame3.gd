class_name TimePlatformingMinigame3
extends TimePlatformingMinigame

@onready var killzone1: Area2D = $Killzones/Killzone1
@onready var killzone2: Area2D = $Killzones/Killzone2
@onready var killzone3: Area2D = $Killzones/Killzone3
@onready var killzone4: Area2D = $Killzones/Killzone4
@onready var camera: HLockCamera = $Camera2D


func _init() -> void:
	_difficulty_times = {
		Difficulty.EASY: 30.0,
		Difficulty.MEDIUM: 20.0,
		Difficulty.HARD: 10.0,
	}
	super._init()
	_payout_multiplier = {
		Difficulty.EASY: 1.25,
		Difficulty.MEDIUM: 2.0,
		Difficulty.HARD: 3.0
	}
	minigame_scene_path = "res://scenes/time_platforming_minigame3.tscn"
	minigame_img_path = "res://assets/minigame_images/time_platforming_game3_img.png"


func _ready() -> void:
	super._ready()
	killzone1.body_entered.connect(_handle_body_entered)
	killzone2.body_entered.connect(_handle_body_entered)
	killzone3.body_entered.connect(_handle_body_entered)
	killzone4.body_entered.connect(_handle_body_entered)
	_difficulty_times = {
		Difficulty.EASY: 10005.0,
		Difficulty.MEDIUM: 10.0,
		Difficulty.HARD: 7.5,
	}
	set_difficulty(Difficulty.EASY)


func _handle_body_entered(_body: Node2D) -> void:
	player.global_position = Vector2(0.0, -8.0)
	camera.lerp_to_player()

class_name TimePlatformingMinigame4
extends TimePlatformingMinigame

@onready var killzone1: Area2D = %Killzone1
@onready var killzone2: Area2D = %Killzone2


func _init() -> void:
	_difficulty_times = {
		Difficulty.EASY: 45.0,
		Difficulty.MEDIUM: 20.0,
		Difficulty.HARD: 5.0,
	}
	super._init()
	_payout_multiplier = {
		Difficulty.EASY: 1.25,
		Difficulty.MEDIUM: 2.0,
		Difficulty.HARD: 3.0
	}
	minigame_scene_path = "res://scenes/time_platforming_minigame4.tscn"
	minigame_img_path = "res://assets/minigame_images/time_platforming_game2_img.png"


func _ready() -> void:
	super._ready()
	killzone1.body_entered.connect(_handle_body_entered)
	killzone2.body_entered.connect(_handle_body_entered)


func _handle_body_entered(_body: Node2D) -> void:
	player.global_position = Vector2(-126.0, 32.0)

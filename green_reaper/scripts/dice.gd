extends Node2D

@export var _show_dice_duration: float
@export var _dice_roll_speed: int

@onready var _animated_dice: AnimatedSprite2D = $AnimatedSprite2D
@onready var board_player: CharacterBody2D = %BoardPlayer
@onready var camera_base: CameraBase = $"../CameraBase"

var num_rolled: int
var times_rolled: int
var rolling_active: bool
var top_reached: bool

var player_y: float
var player_x: float

signal dice_rolled
signal dice_done_waiting


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	num_rolled = 0
	times_rolled = 0
	rolling_active = false
	top_reached = false
	player_x = board_player.position.x
	player_y = board_player.position.y
	z_index = 6
	
	connect("dice_rolled", dice_roll_finished)
	
	visible = false


func _process(delta: float) -> void:
	
	if rolling_active:
		if top_reached and (position.y >= player_y):
			rolling_active = false
			top_reached = false
			emit_signal("dice_rolled")
		elif top_reached and (position.y < player_y):
			position.y += delta * _dice_roll_speed
		elif (position.y > player_y - 20) and (not top_reached):
			position.y -= delta * _dice_roll_speed
		else:
			top_reached = true


func roll_dice() -> int:
	
	position = board_player.position
	player_x = board_player.position.x
	player_y = board_player.position.y
	position.x += 20
	
	camera_base.zoom_in_camera()
	visible = true
	
	# return number 1 - 6
	num_rolled = randi_range(1, 6)
	times_rolled += 1
	
	# handle animation
	_animated_dice.play("rolling")
	rolling_active = true
	
	return num_rolled

func dice_roll_finished() -> void:
	var animation_name: String = "roll" + str(num_rolled)
	_animated_dice.play(animation_name)
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = _show_dice_duration
	timer.one_shot = true
	timer.start()
	await timer.timeout
	emit_signal("dice_done_waiting")
	visible = false
	
	
	
	
	

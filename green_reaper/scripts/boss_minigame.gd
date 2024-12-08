class_name BossMinigame
extends Minigame


const _border_top_left: Vector2 = Vector2(-150, -80)
const _border_bot_right: Vector2 = Vector2(150, 80)
const _difficulty_spawn_rate: Dictionary = {
	Difficulty.EASY: 0.75,
	Difficulty.MEDIUM: 0.5,
	Difficulty.HARD: 0.25,
	Difficulty.FINAL: 0.0,
}
const _timer_duration: float = 20.0

var _chkpt_enemy_scene: PackedScene = preload("res://scenes/checkpoint_enemy.tscn")
var _targets: Dictionary = {
	CheckpointEnemy.Type.NORMAL: [],
	CheckpointEnemy.Type.HAT: [],
	CheckpointEnemy.Type.HORNED: [],
}
var _elapsed_time: float = 0.0
var _spawn_rate: float
var _spawn_enemies = false

@onready var player: PlatformingPlayer = $Player
@onready var game_timer: Timer = $GameTimer
@onready var timer_label: Label = $GameTimer/TimerLabel


func _init() -> void:
	minigame_img_path = "res://assets/minigame_images/internal_timer_minigame_img.png"
	minigame_scene_path = "res://scenes/boss_minigame.tscn"
	minigame_name = "Boss"
	instructions = "Avoid colliding with the enemies. They are out to steal your money!"
	
	_payout_multiplier = {
		Difficulty.EASY: 25000,
		Difficulty.MEDIUM: 50000,
		Difficulty.HARD: 75000,
		Difficulty.FINAL: 100000,
	}


func _ready() -> void:
	super.init()

	game_timer.timeout.connect(_handle_game_timer_timeout)	
	
	countdown_label.start()
	player.unbind_commands()


func _process(delta: float) -> void:
	if not game_timer.is_stopped():
		timer_label.text = "%.2f" % [game_timer.time_left]
	
	player.position.x = clamp(get_global_mouse_position().x, -140, 140)
	player.position.y = clamp(get_global_mouse_position().y, -70, 70)
	_elapsed_time -= delta
	if _elapsed_time <= 0 and _spawn_enemies:
		_spawn_enemy()


func set_difficulty(diff: Difficulty) -> void:
	super.set_difficulty(diff)
	_spawn_rate = _difficulty_spawn_rate[diff]
	_elapsed_time = _spawn_rate
	game_timer.wait_time = _timer_duration
	timer_label.text = "%.2f" % [_timer_duration]


static func pick_rand_position() -> Vector2:
	# Picks a random spawn position for enemies outside of box
	var top_left: Vector2 = _border_top_left
	var bot_right: Vector2 = _border_bot_right
	var pos_x = 0
	var pos_y = 0
	
	var top_bottom_left_or_right = randi() % 4

	if top_bottom_left_or_right == 0:
		pos_x = randf_range(top_left.x, bot_right.x)
		pos_y = top_left.y
	elif top_bottom_left_or_right == 1:
		pos_x = randf_range(top_left.x, bot_right.x)
		pos_y = bot_right.y
	elif top_bottom_left_or_right == 2:
		pos_x = top_left.x
		pos_y = randf_range(top_left.y, bot_right.y)
	elif top_bottom_left_or_right == 3:
		pos_x = bot_right.x
		pos_y = randf_range(top_left.y, bot_right.y)
	
	return Vector2(pos_x, pos_y)


func get_payout(wager: int, difficulty: Difficulty) -> int:
	return _payout_multiplier[difficulty]


func _handle_no_money() -> void:
	var is_timer_stopped: bool = game_timer.is_stopped()
	game_timer.stop()
	
	if not is_timer_stopped:
		_win()
	else:
		_lose()
	
	signal_bus.reached_platforming_goal.disconnect(_handle_no_money)


func _win() -> void:
	super._win()
	player.unbind_commands()
	player.win()


func _lose() -> void:
	super._lose()
	player.unbind_commands()
	player.lose()


func _handle_countdown_ended() -> void:
	_spawn_enemies = true
	game_timer.start()


func _handle_game_timer_timeout() -> void:
	_win()
	timer_label.text = "%.2f" % [0]


func _handle_transition_timer_timeout() -> void:
	signal_bus.end_minigame.emit(_did_player_win)


func _set_target_type(target: CheckpointEnemy) -> CheckpointEnemy:
	var possibilities: Array[CheckpointEnemy.Type] = [CheckpointEnemy.Type.NORMAL]
	if _spawn_rate == 0.5:
		possibilities.append(CheckpointEnemy.Type.HAT)
	if _spawn_rate == 0.25:
		possibilities.append(CheckpointEnemy.Type.HORNED)
	
	target.set_type(possibilities.pick_random())
	return target


func _pick_valid_nonzero_target_type() -> CheckpointEnemy.Type:
	var possibilities: Array[CheckpointEnemy.Type] = []
	if _spawn_rate <= 0.75 and len(_targets[CheckpointEnemy.Type.NORMAL]) > 0:
		possibilities.append(CheckpointEnemy.Type.NORMAL)
	if _spawn_rate == 0.5 and len(_targets[CheckpointEnemy.Type.HAT]) > 0:
		possibilities.append(CheckpointEnemy.Type.HAT)
	if _spawn_rate <= 0.25 and len(_targets[CheckpointEnemy.Type.HORNED]) > 0:
		possibilities.append(CheckpointEnemy.Type.HORNED)
	
	return possibilities.pick_random()


func _spawn_enemy() -> void:
	_elapsed_time = _spawn_rate

	var target: CheckpointEnemy = _chkpt_enemy_scene.instantiate() as CheckpointEnemy
	target = _set_target_type(target)
	call_deferred("add_child", target)
	_targets[target.get_type()].append(target)

class_name BossMinigame
extends Minigame


const _border_top_left: Vector2 = Vector2(-150, -80)
const _border_bot_right: Vector2 = Vector2(150, 80)
const _difficulty_spawn_rate: Dictionary = {
	Difficulty.EASY: 0.50,
	Difficulty.MEDIUM: 0.25,
	Difficulty.HARD: 0.15,
	Difficulty.FINAL: 0.00,
}

var _chkpt_enemy_scene: PackedScene = preload("res://scenes/checkpoint_enemy.tscn")
var _targets: Dictionary = {
	CheckpointEnemy.Type.NORMAL: [],
	CheckpointEnemy.Type.HAT: [],
	CheckpointEnemy.Type.HORNED: [],
	CheckpointEnemy.Type.REAPER: [],
}
var _elapsed_time: float = 0.0
var _spawn_rate: float
var _spawn_enemies = false
var _timer_duration: float = 20.0
var _initial_cash: int
var _cash_has_changed = false

@onready var player: PlatformingPlayer = $Player
@onready var game_timer: Timer = $GameTimer
@onready var timer_label: Label = $GameTimer/TimerLabel
@onready var cash_label: Label = $GameTimer/CashLabel

func _init() -> void:
	minigame_img_path = "res://assets/minigame_images/boss_minigame_img.png"
	minigame_scene_path = "res://scenes/boss_minigame.tscn"
	minigame_name = "Boss"
	instructions = "Avoid colliding with the enemies. They are out to steal your money! Different enemy types steal different amounts of money"
	controls = [Controls.MOVE_MOUSE]
	
	_payout_multiplier = {
		Difficulty.EASY: 250000,
		Difficulty.MEDIUM: 500000,
		Difficulty.HARD: 750000,
		Difficulty.FINAL: 1000000,
	}


func _ready() -> void:
	super.init()

	game_timer.timeout.connect(_handle_game_timer_timeout)	
	signal_bus.reached_platforming_goal.connect(_handle_no_money)
	
	_initial_cash = state_manager.cash
	countdown_label.start()
	player.unbind_commands()


func _process(delta: float) -> void:
	if not game_timer.is_stopped():
		timer_label.text = "%.2f" % [game_timer.time_left]
		cash_label.text = str(state_manager.cash)

	if not _cash_has_changed:
		_cash_has_changed = true if _initial_cash - state_manager.cash != 0 else false

	if _cash_has_changed and state_manager.cash <= 0:
		if is_player_lucky():
			luck_label.display()
			state_manager.cash += 20000
		else:
			signal_bus.reached_platforming_goal.emit()

	player.position.x = clamp(get_global_mouse_position().x, -140, 140)
	player.position.y = clamp(get_global_mouse_position().y, -70, 70)

	_elapsed_time -= delta
	if _elapsed_time <= 0 and _spawn_enemies:
		_spawn_enemy()


func set_difficulty(diff: Difficulty) -> void:
	super.set_difficulty(diff)
	_spawn_rate = _difficulty_spawn_rate[diff]
	_elapsed_time = _spawn_rate

	if diff == Difficulty.EASY:
		_timer_duration = 20.0
	elif diff == Difficulty.MEDIUM:
		_timer_duration = 30.0
	else:
		_timer_duration = 45.0

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
	if state_manager.cash <= 0:
		return state_manager.cash
	return _payout_multiplier[difficulty]


func _set_target_type(target: CheckpointEnemy) -> CheckpointEnemy:
	var possibilities: Array[CheckpointEnemy.Type] = [CheckpointEnemy.Type.NORMAL]
	if _spawn_rate == _difficulty_spawn_rate[Difficulty.MEDIUM]:
		possibilities.append(CheckpointEnemy.Type.HAT)
	if _spawn_rate == _difficulty_spawn_rate[Difficulty.HARD]:
		possibilities.append(CheckpointEnemy.Type.HORNED)
	if _spawn_rate == _difficulty_spawn_rate[Difficulty.FINAL]:
		possibilities.clear()
		possibilities.append(CheckpointEnemy.Type.REAPER)
	
	target.set_type(possibilities.pick_random())
	return target


func _spawn_enemy() -> void:
	_elapsed_time = _spawn_rate

	var target: CheckpointEnemy = _chkpt_enemy_scene.instantiate() as CheckpointEnemy
	target = _set_target_type(target)
	call_deferred("add_child", target)
	_targets[target.get_type()].append(target)


func _handle_no_money() -> void:
	game_timer.stop()
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

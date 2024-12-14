class_name ActionMinigame
extends Minigame

var action_times: Dictionary = {
	Difficulty.EASY: 1.8,
	Difficulty.MEDIUM: 1.0,
	Difficulty.HARD: 0.6,
}

var action_labels: Dictionary = {
	Action.NONE: "",
	Action.MOVE_LEFT: "Move left!",
	Action.MOVE_RIGHT: "Move right!",
	Action.KICK_LEFT: "Kick left!",
	Action.KICK_RIGHT: "Kick right!",
	Action.NO_MOVE: "Don't move!",
	Action.JUMP: "Jump!",
	Action.REACH_COIN: "Get to the coin!",
}

var cur_action: Action
var action_time: float
var game_time: float = 20.0
var coin_loc: Vector2i

@onready var player: PlatformingPlayer = $Player
@onready var game_timer: Timer = %GameTimer
@onready var action_timer: Timer = %ActionTimer
@onready var timer_label: Label = %TimerLabel
@onready var action_label: Label = %ActionLabel


func _init() -> void:
	minigame_img_path = "res://assets/minigame_images/action_minigame_img.png"
	minigame_scene_path = "res://scenes/action_minigame.tscn"
	minigame_name = "Simon Says"
	instructions = "Follow the instructions as they appear on the screen."
	tooltip_format = "Expected to react in %.2f seconds"
	easy_tooltip = tooltip_format % [action_times[Difficulty.EASY]]
	medium_tooltip = tooltip_format % [action_times[Difficulty.MEDIUM]]
	hard_tooltip = tooltip_format % [action_times[Difficulty.HARD]]
	controls = [Controls.MOVE_LEFT, Controls.MOVE_RIGHT, Controls.KICK, Controls.JUMP]
	cur_action = Action.NONE
	
	_payout_multiplier = {
		Difficulty.EASY: 1.25,
		Difficulty.MEDIUM: 2.0,
		Difficulty.HARD: 3.0
	}


func _ready() -> void:
	super.init()

	game_timer.timeout.connect(_handle_game_timer_timeout)
	action_timer.timeout.connect(_handle_action_timeout)
	countdown_label.start()
	player.unbind_commands()
	player.disable()


func _process(_delta: float) -> void:
	if not game_timer.is_stopped():
		timer_label.text = "%.2f" % [game_timer.time_left]

		if cur_action != Action.NO_MOVE:
			_check_cur_action()


func get_payout(wager: int, difficulty: Difficulty) -> int:
	return int(wager * _payout_multiplier[difficulty])


func set_difficulty(diff: Difficulty) -> void:
	super.set_difficulty(diff)
	action_time = action_times[diff]
	game_timer.wait_time = game_time
	timer_label.text = "%.2f" % [game_time]


func _win() -> void:
	super._win()
	action_timer.stop()
	player.unbind_commands()
	player.win()


func _lose() -> void:
	super._lose()
	player.unbind_commands()
	player.lose()

# Take 1 second breaks between actions
func _start_break_action() -> void:
	if cur_action == Action.REACH_COIN:
		$TileMapLayer.set_cell(coin_loc, 1, Vector2i(0, 0))
	cur_action = Action.NONE
	_display_action_label()
	action_timer.start(1.0)


func _select_new_action() -> void:
	# Skip the break action
	cur_action = Action.values()[randi_range(1, Action.size() - 1)]
	_display_action_label()
	if cur_action == Action.REACH_COIN:
		var coin_x: int = randi_range(-31, 4)
		var coin_y: int = 9
		coin_loc = Vector2i(coin_x, coin_y)
		$TileMapLayer.set_cell(coin_loc, 1, Vector2i(2, 0))
		action_timer.start(action_time + 2.5)
	elif cur_action == Action.NO_MOVE:
		action_timer.start(0.5 * action_time)
	else:
		action_timer.start(action_time)


func _display_action_label() -> void:
	action_label.text = action_labels[cur_action]


func _handle_action_timeout() -> void:
	if cur_action == Action.NONE:
		_select_new_action()
	elif cur_action == Action.NO_MOVE and not _is_kicking() and player.velocity.x == 0:
		_start_break_action()
	else:
		if is_player_lucky():
			luck_label.display()
			_start_break_action()
		else:
			game_timer.stop()
			_lose()


func _check_cur_action() -> void:
	print(cur_action)
	if cur_action == Action.MOVE_LEFT and player.velocity.x < 0 or \
	cur_action == Action.MOVE_RIGHT and player.velocity.x > 0 or \
	cur_action == Action.JUMP and player.velocity.y > 0 or \
	cur_action == Action.KICK_LEFT and _is_kicking() and _is_facing_left() or \
	cur_action == Action.KICK_RIGHT and _is_kicking() and _is_facing_right() or \
	cur_action == Action.JUMP and _is_jumping() or \
	cur_action == Action.REACH_COIN and _player_reached_coin():
		_start_break_action()


func _player_reached_coin():
	var player_tile = $TileMapLayer.local_to_map($TileMapLayer.to_local(player.global_position))
	# print(player_tile)
	return player_tile == coin_loc


func _handle_countdown_ended() -> void:
	player.bind_commands()
	player.enable()
	game_timer.start()
	_start_break_action()


func _handle_game_timer_timeout() -> void:
	_win()


func _handle_transition_timer_timeout() -> void:
	signal_bus.end_minigame.emit(_did_player_win)


func _is_kicking():
	return player._animation_tree["parameters/conditions/is_kicking"]


func _is_jumping():
	return player._animation_tree["parameters/conditions/is_jumping"]


func _is_facing_left():
	return player.sprite.scale.x < 0


func _is_facing_right():
	return player.sprite.scale.x > 0

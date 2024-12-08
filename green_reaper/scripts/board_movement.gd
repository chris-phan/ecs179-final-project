extends CharacterBody2D

@onready var _spaces: Node = $"../Spaces"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dice: Node2D = $"../Dice"
@onready var test_board: Node2D = $".."
@onready var board: Node2D = $".."

@export var _player_speed: int = 80

var board_vectors: Array[Vector2] = []
var _moves: int = 0
var _current_space: int = 0 # index of space
var _next_space: int = 1 # index of next space
var _current_animation: String = "idle"
var _disabled: bool
var space_indicators: Array[String] = []
var dice_rolling_done: bool
var move_done: bool

signal space_landed(space_type)


func _ready() -> void:
	dice_rolling_done = false
	move_done = true
	z_index = 5
	# go to idle animation
	animation_player.play("idle")
	board.connect("board_setup_done", _on_board_setup_done)
	dice.connect("dice_done_waiting", set_dice_rolling_done)
	signal_bus.exit_minigame.connect(_enable_dice)
	

func _on_board_setup_done() -> void:
	# initialize board
	for child in _spaces.get_children():
		board_vectors.append(Vector2(child.global_position.x, child.global_position.y - 5))
		
		if "event" in child.name:
			space_indicators.append("event")
		elif "gain_money" in child.name:
			space_indicators.append("gain_money")
		elif "gain_luck" in child.name:
			space_indicators.append("gain_luck")
		elif "lose_money" in child.name:
			space_indicators.append("lose_money")
		elif "lose_luck" in child.name:
			space_indicators.append("lose_luck")
		else:
			space_indicators.append("unknown space")
		
	position = board_vectors[0]
	

func _process(_delta: float) -> void:
	
	if _disabled:
		return
	
	# something trigger dice roll (for now it's 'space')
	if move_done and Input.is_action_just_pressed("roll_dice"):
		# print("d pressed")
		move_done = false
		_moves = dice.roll_dice()
		print("dice: " + str(_moves))

	if dice_rolling_done:
		# after dice roll
		if _moves > 0:
			if _current_space == len(board_vectors) - 1:
				_next_space = 0
			
			if position.x < board_vectors[_next_space].x:
				position.x += _delta * _player_speed
				if position.x >= board_vectors[_next_space].x:
					position.x = board_vectors[_next_space].x
				# walking right
				animation_player.play("right")
			elif position.x > board_vectors[_next_space].x:
				position.x -= _delta * _player_speed
				if position.x <= board_vectors[_next_space].x:
					position.x = board_vectors[_next_space].x
				# walking left
				animation_player.play("left")
			elif position.y > board_vectors[_next_space].y:
				position.y -= _delta * _player_speed
				if position.y < board_vectors[_next_space].y:
					position.y = board_vectors[_next_space].y
				# walking up
				animation_player.play("up")
			elif position.y < board_vectors[_next_space].y:
				position.y += _delta * _player_speed
				if position.y > board_vectors[_next_space].y:
					position.y = board_vectors[_next_space].y
				# walking down
				animation_player.play("down")
			else:
				# destination reached
				sfx_player.play_board_move()
				_moves -= 1
				_current_space = _next_space
				position = board_vectors[_current_space];
				_next_space += 1
				#print("move done")
				
				# check if it's last move
				if _moves == 0:
					animation_player.play("idle")
					# check which space it is on an emit signal depending on it.
					emit_signal("space_landed", space_indicators[_current_space])
					print("landed on " + space_indicators[_current_space] + " space")
					dice_rolling_done = false


func _enable_dice() -> void:
	move_done = true


func set_dice_rolling_done() -> void:
	dice_rolling_done = true

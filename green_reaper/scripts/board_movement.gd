extends CharacterBody2D

@onready var _spaces: Node = $"../Spaces"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dice: Node2D = %Dice
@onready var test_board: Node2D = $".."

@export var _player_speed: int = 80

var board_vectors: Array[Vector2] = []
var _moves: int = 0
var _current_space: int = 0 # index of space
var _next_space: int = 1 # index of next space
var _current_animation: String = "idle"
var space_indicators: Array[String] = []

signal space_landed(space_type)
#signal board_setup_done

func _ready() -> void:
	# go to idle animation
	animation_player.play("idle")
	
	# initialize board
	for child in _spaces.get_children():
		board_vectors.append(child.global_position)
		#print(child.name)
		
		if "event" in child.name:
			space_indicators.append("event")
		elif "good" in child.name:
			space_indicators.append("good")
		elif "bad" in child.name:
			space_indicators.append("bad")
		else:
			space_indicators.append("unknown space")
		
		#print("pos: ", child.global_position)
	
	# move player to first space
	position = board_vectors[0]
	#emit_signal("board_setup_done")
	

func _process(_delta: float) -> void:
	
	# something trigger dice roll (for now it's 'd')
	if Input.is_action_just_pressed("roll_dice"):
		#print("d pressed")
		_moves = dice.roll_dice()
		print("dice: " + str(_moves))
		print("turn: " + str(test_board.get_turns_passed()))

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
			_moves -= 1
			_current_space = _next_space
			position = board_vectors[_current_space];
			_next_space += 1
			animation_player.play("idle")
			#print("move done")
			
			# check if it's last move
			if _moves == 0:
				# check which space it is on an emit signal depending on it.
				emit_signal("space_landed", space_indicators[_current_space])
				print("landed on " + space_indicators[_current_space] + " space")

extends CharacterBody2D

@onready var _spaces: Node = $"../Spaces"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var board_vectors: Array[Vector2] = []

func _ready() -> void:
	# go to idle animation
	animation_player.play("idle")
	
	# initialize board
	for child in _spaces.get_children():
		board_vectors.append(child.global_position)
		print("pos: ", child.global_position)
	
	# move player to first space
	global_position = board_vectors[0]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

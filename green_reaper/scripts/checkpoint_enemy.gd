class_name CheckpointEnemy
extends CharacterBody2D

enum Type {
	NORMAL,
	HAT,
	HORNED,
	REAPER,
}

const _SCALES: Array[Vector2] = [
		Vector2(0.5, 0.5),
		Vector2(0.75, 0.75),
		Vector2(1.0, 1.0),
		Vector2(1.25, 1.25),
		Vector2(1.5, 1.5),
]
const _DAMAGE := {
	Type.NORMAL : 10000,
	Type.HAT : 20000,
	Type.HORNED : 50000,
	Type.REAPER : 75000,
}

var _type: Type
var _disabled: bool = false
var _start_pos: Vector2
var speed: float = 50.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: PlatformingPlayer = get_node("../Player")


func _ready() -> void:
	scale = _SCALES.pick_random()
	global_position = BossMinigame.pick_rand_position()
	_start_pos = global_position
	speed = randf_range(25, 75)
	animation_player.speed_scale = randf_range(0.5, 1)
	animation_player.play("move" + str(_type))


func _physics_process(delta: float) -> void:
	if _disabled:
		return
	
	if _type == Type.NORMAL:
		var collision = move_and_collide(_start_pos.direction_to(-_start_pos) * speed * delta)
		_handle_collision(collision)
	elif _type == Type.HAT:
		var percentage_error = randf_range(-0.1, 0.1)
		var player_position = player.global_position
		player_position *= percentage_error
		var collision = move_and_collide(_start_pos.direction_to(player_position) * speed * delta)
		_handle_collision(collision)
	else:
		var player_position = player.global_position
		var collision = move_and_collide(_start_pos.direction_to(player_position) * speed * delta)
		_handle_collision(collision)


func disable() -> void:
	_disabled = true
	scale = Vector2(1.0, 1.0)
	animation_player.speed_scale = 1.0


func get_type() -> Type:
	return _type


func set_type(type: Type) -> void:
	_type = type
	if animation_player != null:
		animation_player.play("move" + str(type))


func _handle_collision(collision: KinematicCollision2D) -> void:
	if !collision:
		return
	state_manager.cash -= _DAMAGE[_type]
	sfx_player.play_board_move()
	queue_free()

class_name ObservationTarget
extends CharacterBody2D

enum Type {
	NORMAL,
	HAT,
	HORNED,
}

const _SCALES: Array[Vector2] = [
		Vector2(0.5, 0.5),
		Vector2(0.75, 0.75),
		Vector2(1.0, 1.0),
		Vector2(1.25, 1.25),
		Vector2(1.5, 1.5),
]
var _move_to_pos: Vector2
var _type: Type
var _disabled: bool = false
var speed: int = 50

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var rand_scale: float = randf_range(0.5, 1.5)
	scale = _SCALES.pick_random()
	_move_to_pos = ObservationMinigame.pick_rand_position(collision_shape.shape.size.x)
	speed = randi_range(25, 75)
	animation_player.speed_scale = randf_range(0.5, 1)
	animation_player.play("move" + str(_type))


func _physics_process(delta: float) -> void:
	if _disabled:
		return
	
	if global_position == _move_to_pos:
		_move_to_pos = ObservationMinigame.pick_rand_position(collision_shape.shape.size.x)
	
	global_position.x = move_toward(global_position.x, _move_to_pos.x, speed * delta)
	global_position.y = move_toward(global_position.y, _move_to_pos.y, speed * delta)


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

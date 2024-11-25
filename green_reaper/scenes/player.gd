class_name Character
extends CharacterBody2D

const TERMINAL_VELOCITY: float = 700.0
const DEFAULT_JUMP_VELOCITY: float = -400.0
const DEFAULT_MOVE_VELOCITY: float = 300.0

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void: 
	_apply_gravity(delta)
	_apply_movement(delta)


func _apply_movement(_delta: float):
	move_and_slide()


func _apply_gravity(delta: float) -> void:
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)

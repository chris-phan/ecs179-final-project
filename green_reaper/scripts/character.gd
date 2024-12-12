class_name Character
extends CharacterBody2D

const TERMINAL_VELOCITY: float = 700.0
const DEFAULT_JUMP_VELOCITY: float = -400.0
const DEFAULT_MOVE_VELOCITY: float = 300.0

var movement_speed: float = DEFAULT_MOVE_VELOCITY
var jump_velocity: float = DEFAULT_JUMP_VELOCITY
var gravity: int = ProjectSettings.get("physics/2d/default_gravity")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	pass

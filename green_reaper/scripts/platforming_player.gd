class_name PlatformingPlayer
extends Character

var _disabled: bool = false
var _right_cmd: Command
var _left_cmd: Command
var _jump_cmd: Command
var _kick_cmd: Command
var _idle_cmd: Command

@onready var _animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:
	movement_speed = 100
	jump_velocity = -300
	bind_commands()


func _physics_process(delta: float) -> void:
	if _disabled:
		return
	
	update_animation_params()
	
	var move_input: float = (Input.get_action_strength("move_right") -
			Input.get_action_strength("move_left"))
	
	if move_input > 0.1:
		_right_cmd.execute(self)
	elif move_input < -0.1:
		_left_cmd.execute(self)
	else:
		_idle_cmd.execute(self)
	
	if Input.is_action_just_pressed("jump"):
		_animation_tree["parameters/conditions/is_jumping"] = true
		_jump_cmd.execute(self)
	
	if Input.is_action_just_pressed("kick"):
		_animation_tree["parameters/conditions/is_kicking"] = true
		#_kick_cmd.execute(self)
	
	_apply_gravity(delta)
	_apply_movement(delta)


func bind_commands() -> void:
	_right_cmd = PlatformingPlayerMoveRightCommand.new()
	_left_cmd = PlatformingPlayerMoveLeftCommand.new()
	_jump_cmd = PlatformingPlayerJumpCommand.new()
	_kick_cmd = PlatformingPlayerKickCommand.new()
	_idle_cmd = PlatformingPlayerIdleCommand.new()


func unbind_commands() -> void:
	_right_cmd = Command.new()
	_left_cmd = Command.new()
	_jump_cmd = Command.new()
	_kick_cmd = Command.new()
	_idle_cmd = Command.new()


func win() -> void:
	_animation_tree["parameters/conditions/win"] = true
	velocity.x = 0


func lose() -> void:
	_animation_tree["parameters/conditions/lose"] = true
	velocity.x = 0


func disable() -> void:
	_disabled = true


func _apply_movement(_delta: float) -> void:
	move_and_slide()


func _apply_gravity(delta: float) -> void:
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)


func update_animation_params():
	if !is_zero_approx(velocity.length()):
		_animation_tree["parameters/conditions/is_moving"] = true
		_animation_tree["parameters/conditions/is_idle"] = false
		_animation_tree["parameters/conditions/is_landing"] = false
	else:
		_animation_tree["parameters/conditions/is_idle"] = true
		_animation_tree["parameters/conditions/is_moving"] = false
		_animation_tree["parameters/conditions/is_landing"] = false
	
	if is_on_floor():
		if _animation_tree["parameters/conditions/is_falling"]:
			# Was falling
			_animation_tree["parameters/conditions/is_falling"] = false
			_animation_tree["parameters/conditions/is_landing"] = true
	else:
		_animation_tree["parameters/conditions/is_falling"] = true
		_animation_tree["parameters/conditions/is_idle"] = false
		_animation_tree["parameters/conditions/is_moving"] = false
	
	_animation_tree["parameters/conditions/is_jumping"] = false
	_animation_tree["parameters/conditions/is_kicking"] = false

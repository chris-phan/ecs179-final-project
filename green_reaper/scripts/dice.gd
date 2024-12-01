extends Node2D

static var num_rolled: int
static var times_rolled: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	num_rolled = 0
	times_rolled = 0


static func roll_dice() -> int:
	
	# handle animation
	
	# return number 1 - 6
	num_rolled = randi_range(1, 6)
	times_rolled += 1
	
	return num_rolled

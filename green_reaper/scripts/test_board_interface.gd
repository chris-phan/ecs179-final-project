extends Node2D

@onready var dice: Node2D = %Dice


func get_turns_passed():
	return dice.times_rolled
	
## TODO 

# function to set points
# function to set luck

# function to get points
# function to get luck

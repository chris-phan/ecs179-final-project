class_name Board
extends Node2D

@onready var spaces: Node = $Spaces

const TOP_LEFT_X: int = -512
const TOP_LEFT_Y: int = -234
const NUMBER_OF_SPACES: int = 24

var event_space: PackedScene = preload("res://scenes/event_space.tscn")
var gain_luck_space: PackedScene = preload("res://scenes/gain_luck_space.tscn")
var lose_luck_space: PackedScene = preload("res://scenes/lose_luck_space.tscn")
var gain_money_space: PackedScene = preload("res://scenes/gain_money_space.tscn")
var lose_money_space: PackedScene = preload("res://scenes/lose_money_space.tscn")
var space_list: Array[Node] = []
@onready var camera_base: CameraBase = $CameraBase

signal board_setup_done


func _ready() -> void:
	# fill space_list
	# 4 gain money
	# 4 lose money
	# 4 gain luck
	# 4 lose luck
	# 8 event spaces
	var space_num = 1
	for i in range(4 + 4):
		var space: Node = gain_money_space.instantiate()
		space.name = "gain_money_space" + str(space_num)
		space_list.push_back(space)
		space_num += 1
	
	for i in range(4 + 4):
		var space: Node = lose_money_space.instantiate()
		space.name = "lose_money_space" + str(space_num)
		space_list.push_back(space)
		space_num += 1
	
	for i in range(4):
		var space: Node = gain_luck_space.instantiate()
		space.name = "gain_luck_space" + str(space_num)
		space_list.push_back(space)
		space_num += 1
	
	for i in range(4):
		var space: Node = lose_luck_space.instantiate()
		space.name = "lose_luck_space" + str(space_num)
		space_list.push_back(space)
		space_num += 1
	
	#for i in range(8):
		#var space: Node = event_space.instantiate()
		#space.name = "event_space" + str(space_num)
		#space_list.push_back(space)
		#space_num += 1

	# initialize the board wth 24 spaces
	space_list.shuffle()
	
	for space in space_list:
		spaces.add_child(space)
		
	var cur_x: int = TOP_LEFT_X
	var cur_y: int = TOP_LEFT_Y
	
	# first space
	space_list[0].position.x = cur_x
	space_list[0].position.y = cur_y
	
	var space_count: int = 1
	var switch_dir: int = 1
	
	cur_x -= 192
	
	# bottom 18 spaces
	for i in range(6):
		if not i == 3:
			cur_x += 192
		else:
			cur_x += 256
			
		for j in range(3):
			cur_y += 192 * switch_dir
			space_list[space_count].position.x = cur_x
			space_list[space_count].position.y = cur_y
			space_count += 1
			
		cur_y += 192 * switch_dir
		switch_dir *= -1
	
	# 5 spaces to the right of the first space
	for i in range(5):
		space_list[space_count].position.x = cur_x
		space_list[space_count].position.y = cur_y
		
		if not i == 2:
			cur_x -= 192
		else:
			cur_x -= 256
		
		space_count += 1
	
	emit_signal("board_setup_done")


func _process(delta: float) -> void:
	pass

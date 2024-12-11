class_name EventManager
extends Node2D

var event_rotation: Array[Event]
var cur_event: Event
var cur_scene: Node

var old_balance: int
var new_balance: int
var payout: int
var luck_diff: float


func _ready() -> void:
	signal_bus.enter_event.connect(_handle_enter_event)
	signal_bus.end_event.connect(_handle_end_event)
	signal_bus.exit_event.connect(_handle_exit_event)
	signal_bus.reset_game.connect(_delete_event_manager)
	
	old_balance = 50000

	# _init_event_rotation()


func get_event_name() -> String:
	return cur_event.event_name


func get_event_body() -> String:
	return cur_event.event_body


func get_payout() -> int:
	return cur_event.get_payout()


func _init_event_rotation() -> void:
	event_rotation.append(BeggarEvent.new())
	event_rotation.append(WizardEvent.new())
	event_rotation.shuffle()


func _handle_enter_event() -> void:
	show()
	old_balance = state_manager.cash
	
	var packed_scene = load("res://scenes/event_ui.tscn")
	cur_scene = packed_scene.instantiate() as EventUI
	cur_scene.set_event_manager(self)
	cur_scene.global_position = Vector2(0.0, 0.0)
	add_child(cur_scene)

	#if len(event_rotation) == 0:
		#_init_event_rotation()
	
	# cur_event = event_rotation.pop_back()
	cur_event = _init_random_event()
	cur_scene.set_labels()


# Event rotation since events can't be initialized beforehand (very jank)
func _init_random_event() -> Event:
	var num_events: int = 5
	var ind: int = randi() % num_events
	if ind == 0:
		return BeggarEvent.new()
	elif ind == 1:
		return WizardEvent.new()
	elif ind == 2:
		return CarEvent.new()
	elif ind == 3:
		return CharityEvent.new()
	elif ind == 4:
		return KidEvent.new()
	return null


func _handle_end_event() -> void:
	payout = cur_event.get_payout()
	luck_diff = cur_event.get_luck_diff()
	print("luck_diff = " + str(luck_diff))

	cur_scene.queue_free()
	cur_scene = load("res://scenes/event_result_ui.tscn").instantiate() as EventResultUI
	add_child(cur_scene)
	cur_scene.global_position = Vector2(0.0, 0.0)

	new_balance = old_balance + payout
	state_manager.cash = new_balance
	if luck_diff >= 0:
		state_manager.inc_luck(luck_diff)
	else:
		state_manager.dec_luck(-luck_diff)

	state_manager.cash = new_balance
	cur_scene.set_event_manager(self)
	cur_scene.set_labels()


func _handle_exit_event() -> void:
	signal_bus.enter_minigame.emit()
	cur_scene.queue_free()
	hide()


func _delete_event_manager() -> void:
	queue_free()

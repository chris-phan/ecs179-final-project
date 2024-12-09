class_name EventManager
extends Node2D

var event_rotation: Array[Event]
var cur_event: Event
var cur_scene: Node

var old_balance: int
var new_balance: int
var payout: int


func _ready() -> void:
	signal_bus.enter_event.connect(_handle_enter_event)
	signal_bus.end_event.connect(_handle_end_event)
	signal_bus.exit_event.connect(_handle_exit_event)
	
	old_balance = 50000

	_init_event_rotation()

func get_event_name() -> String:
	return cur_event.event_name

func get_event_body() -> String:
	return cur_event.event_body

func get_payout() -> int:
	return cur_event.get_payout()

func _init_event_rotation() -> void:
	event_rotation.append(BeggarEvent.new(old_balance))
	event_rotation.append(WizardEvent.new(old_balance))
	event_rotation.shuffle()

func _handle_enter_event() -> void:
	show()
	sfx_player.play_sunday_drive()

	var packed_scene = load("res://scenes/event_ui.tscn")
	cur_scene = packed_scene.instantiate() as EventUI
	cur_scene.set_event_manager(self)
	cur_scene.global_position = Vector2(0.0, 0.0)
	add_child(cur_scene)

	if len(event_rotation) == 0:
		_init_event_rotation()
	
	cur_event = event_rotation.pop_back()

	cur_scene.set_labels()

func _handle_end_event() -> void:
	payout = cur_event.get_payout()
	
	cur_scene.queue_free()
	cur_scene = load("res://scenes/event_result_ui.tscn").instantiate() as EventResultUI
	add_child(cur_scene)
	cur_scene.global_position = Vector2(0.0, 0.0)

	new_balance = old_balance + payout
	state_manager.cash = new_balance

	cur_scene.set_event_manager(self)
	cur_scene.set_labels()

func _handle_exit_event() -> void:
	cur_scene.queue_free()
	hide()

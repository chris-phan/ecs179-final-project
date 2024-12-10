class_name EventUI
extends ColorRect

var event_manager: EventManager

@onready var event_name_label: Label = %EventName
@onready var event_body_label: Label = %EventBody
@onready var option_1_button: Button = %Option1Button
@onready var option_2_button: Button = %Option2Button
@onready var ok_button: Button = %OkButton

func _ready() -> void:
	option_1_button.button_up.connect(_handle_option_1_button_up)
	option_2_button.button_up.connect(_handle_option_2_button_up)
	ok_button.button_up.connect(_handle_ok_button_up)

func set_event_manager(em: EventManager) -> void:
	event_manager = em

func set_event_name() -> void:
	event_name_label.text = event_manager.get_event_name()

func set_event_body() -> void:
	event_body_label.text = event_manager.get_event_body()

func set_buttons() -> void:
	option_1_button.get_parent().visible = event_manager.cur_event.op_1_visible
	option_2_button.get_parent().visible = event_manager.cur_event.op_2_visible
	option_1_button.text = event_manager.cur_event.op_1_text
	option_2_button.text = event_manager.cur_event.op_2_text
	ok_button.get_parent().visible = event_manager.cur_event.ok_visible

func set_labels() -> void:
	set_event_name()
	set_event_body()
	set_buttons()

func _handle_option_1_button_up() -> void:
	sfx_player.play_button_press()
	event_manager.cur_event.select_option(1)
	set_labels()

func _handle_option_2_button_up() -> void:
	sfx_player.play_button_press()
	event_manager.cur_event.select_option(2)
	set_labels()

func _handle_ok_button_up() -> void:
	sfx_player.play_button_press()
	event_manager.cur_event.end_event()

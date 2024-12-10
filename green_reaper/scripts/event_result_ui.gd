class_name EventResultUI
extends ColorRect

var event_manager: EventManager
var _idx: int = 0
var _new_balance: int
var _tween: Tween

@export var stagger_list: Array[Node] = []
@onready var timer: Timer = $Timer
@onready var event_label: Label = %EventName
@onready var done_button_panel: Panel = %DoneButtonPanel
@onready var done_button: Button = %DoneButton
@onready var player: PlatformingPlayer = $Player
@onready var payout_label: Label = %PayoutAmount
@onready var old_balance_label: Label = %OldBalanceAmount
@onready var increment_label: Label = %Increment
@onready var increment_amount_label: Label = %IncrementAmount
@onready var new_balance_label: Label = %BalanceAmount

func _ready() -> void:
	done_button_panel.hide()
	_hide_stagger_list()
	timer.timeout.connect(_handle_timeout)
	done_button.button_up.connect(_handle_done_button_up)
	player.disable()
	timer.start()


func _process(_delta: float) -> void:
	if _new_balance != int(new_balance_label.text):
		sfx_player.play_money_counter()
	new_balance_label.text = str(_new_balance)

func set_event_manager(em: EventManager) -> void:
	event_manager = em

func set_event_label() -> void:
	event_label.text = str(event_manager.get_event_name())

func set_payout() -> void:
	payout_label.text = str(event_manager.payout)

func set_old_balance() -> void:
	old_balance_label.text = str(event_manager.old_balance)

func set_increment() -> void:
	if event_manager.payout >= 0:
		increment_amount_label.text = str(event_manager.payout)
		increment_label.text = "+"
	else:
		increment_amount_label.text = str(-event_manager.payout)
		increment_label.text = "-"

# func set_new_balance() -> void:
# 	_new_balance = event_manager.old_balance
# 	new_balance_label.text = str(_new_balance)


func set_labels() -> void:
	set_event_label()
	set_payout()
	set_old_balance()
	set_increment()


func _hide_stagger_list() -> void:
	for node in stagger_list:
		node.hide()


func _handle_timeout() -> void:
	if _idx < len(stagger_list):
		stagger_list[_idx].show()
		if not stagger_list[_idx] is PlatformingPlayer:
			sfx_player.play_show_result()

		# Play idle animation for player
		if stagger_list[_idx] is PlatformingPlayer:
			pass
		
		# Hacky: Needs the new balance label to be at index 4
		if _idx == 4:
			_new_balance = event_manager.old_balance
			_tween = create_tween()
			_tween.tween_property(self, "_new_balance", event_manager.new_balance, 3.0)
			_tween.finished.connect(_handle_tween_finished)
		
		_idx += 1
		timer.start()


func _handle_done_button_up() -> void:
	sfx_player.stop()
	sfx_player.play_button_press()
	signal_bus.exit_event.emit()


func _handle_tween_finished() -> void:
	done_button_panel.show()
	

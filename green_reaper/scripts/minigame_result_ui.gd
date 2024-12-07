class_name MinigameResultUI
extends ColorRect

var minigame_manager: MinigameManager
var _idx: int = 0
var _new_balance: int
var _tween: Tween

@export var stagger_list: Array[Node] = []
@onready var timer: Timer = $Timer
@onready var done_button_panel: Panel = %DoneButtonPanel
@onready var done_button: Button = %DoneButton
@onready var player: PlatformingPlayer = $Player
@onready var difficulty_label: Label = %SelectedDifficultyValue
@onready var wager_label: Label = %WagerAmount
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


func set_minigame_manager(mm: MinigameManager) -> void:
	minigame_manager = mm


func set_difficulty() -> void:
	difficulty_label.text = Minigame.difficulty_name(minigame_manager.difficulty)


func set_wager() -> void:
	wager_label.text = str(minigame_manager.wager)


func set_payout() -> void:
	payout_label.text = str(minigame_manager.payout)


func set_old_balance() -> void:
	old_balance_label.text = str(minigame_manager.old_balance)


func set_increment() -> void:
	if minigame_manager.won:
		increment_amount_label.text = str(minigame_manager.payout - minigame_manager.wager)
		increment_label.text = "+"
	else:
		increment_amount_label.text = str(minigame_manager.wager)
		increment_label.text = "-"


func set_done_button() -> void:
	if minigame_manager.won:
		done_button.text = "NICE!"
	else:
		done_button.text = "DARN!"


func set_new_balance() -> void:
	_new_balance = minigame_manager.old_balance
	new_balance_label.text = str(_new_balance)


func set_labels() -> void:
	set_difficulty()
	set_wager()
	set_payout()
	set_old_balance()
	set_increment()
	set_done_button()
	set_new_balance()


func _hide_stagger_list() -> void:
	for node in stagger_list:
		node.hide()


func _handle_timeout() -> void:
	if _idx < len(stagger_list):
		stagger_list[_idx].show()
		if not stagger_list[_idx] is PlatformingPlayer:
			sfx_player.play_show_result()
		
		# Play corresponding animation for player
		if stagger_list[_idx] is PlatformingPlayer:
			if minigame_manager.won:
				stagger_list[_idx].win()
			else:
				stagger_list[_idx].lose()
		
		# Hacky: Needs the new balance label to be at index 5
		if _idx == 5:
			_new_balance = minigame_manager.old_balance
			_tween = create_tween()
			_tween.tween_property(self, "_new_balance", minigame_manager.new_balance, 3.0)
			_tween.finished.connect(_handle_tween_finished)
		
		_idx += 1
		timer.start()


func _handle_done_button_up() -> void:
	signal_bus.exit_minigame.emit()


func _handle_tween_finished() -> void:
	done_button_panel.show()
	

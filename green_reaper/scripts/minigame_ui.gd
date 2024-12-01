class_name MinigameUI
extends ColorRect

var wager_inc_button_down: bool = false
var wager_dec_button_down: bool = false
var minigame_manager: MinigameManager

@onready var game_name_label: Label = %GameName
@onready var next_button: Button = %NextButton
@onready var start_button: Button = %StartButton
@onready var tabs: TabContainer = $MarginContainer/TabContainer
@onready var instructions_label: Label = %InstructionsBody
@onready var easy_button: Button = %EasyButton
@onready var medium_button: Button = %MediumButton
@onready var hard_button: Button = %HardButton
@onready var wager_inc_button: Button = %WagerIncButton
@onready var wager_dec_button: Button = %WagerDecButton
@onready var difficulty_value: Label = %SelectedDifficultyValue
@onready var wager_amount_label: Label = %WagerAmount
@onready var payout_amount_label: Label = %PayoutAmount

# Allows holding down increment/decrement buttons
# Starts continuously calling inc/dec wager after waiting hold_timer's wait_time
# Calls inc/dec wager after waiting for inc_timer's wait_time
@onready var hold_timer: Timer = $HoldTimer
@onready var inc_timer: Timer = $IncTimer


func _ready() -> void:
	next_button.button_up.connect(_handle_next_button_up)
	start_button.button_up.connect(_handle_start_button_up)
	easy_button.button_up.connect(_handle_easy_button_up)
	medium_button.button_up.connect(_handle_medium_button_up)
	hard_button.button_up.connect(_handle_hard_button_up)
	
	wager_inc_button.button_down.connect(_handle_wager_inc_button_down)
	wager_inc_button.button_up.connect(_handle_wager_inc_button_up)
	
	wager_dec_button.button_down.connect(_handle_wager_dec_button_down)
	wager_dec_button.button_up.connect(_handle_wager_dec_button_up)

	hold_timer.timeout.connect(_handle_hold_timer_timeout)
	inc_timer.timeout.connect(_handle_inc_timer_timeout)


func set_minigame_manager(mm: MinigameManager) -> void:
	minigame_manager = mm


func set_game_name() -> void:
	game_name_label.text = minigame_manager.minigame_name


func set_instructions() -> void:
	instructions_label.text = minigame_manager.instructions


func set_initial_wager() -> void:
	wager_amount_label.text = str(minigame_manager.wager)


func set_initial_payout() -> void:
	payout_amount_label.text = str(minigame_manager.get_payout())


func set_labels() -> void:
	set_game_name()
	set_instructions()
	set_initial_wager()
	set_initial_payout()


func _inc_wager() -> void:
	wager_amount_label.text = str(minigame_manager.increase_wager())
	payout_amount_label.text = str(minigame_manager.get_payout())


func _dec_wager() -> void:
	wager_amount_label.text = str(minigame_manager.decrease_wager())
	payout_amount_label.text = str(minigame_manager.get_payout())


func _handle_next_button_up() -> void:
	tabs.current_tab = 1


func _handle_start_button_up() -> void:
	signal_bus.start_minigame.emit()


func _handle_easy_button_up() -> void:
	minigame_manager.difficulty = Minigame.Difficulty.EASY
	difficulty_value.text = "EASY"
	payout_amount_label.text = str(minigame_manager.get_payout())


func _handle_medium_button_up() -> void:
	minigame_manager.difficulty = Minigame.Difficulty.MEDIUM
	difficulty_value.text = "MEDIUM"
	payout_amount_label.text = str(minigame_manager.get_payout())


func _handle_hard_button_up() -> void:
	minigame_manager.difficulty = Minigame.Difficulty.HARD
	difficulty_value.text = "HARD"
	payout_amount_label.text = str(minigame_manager.get_payout())


func _handle_wager_inc_button_down() -> void:
	wager_inc_button_down = true
	hold_timer.start()
	_inc_wager()


func _handle_wager_inc_button_up() -> void:
	wager_inc_button_down = false
	hold_timer.stop()
	inc_timer.stop()


func _handle_wager_dec_button_down() -> void:
	wager_dec_button_down = true
	hold_timer.start()
	_dec_wager()


func _handle_wager_dec_button_up() -> void:
	wager_dec_button_down = false
	hold_timer.stop()
	inc_timer.stop()


func _handle_hold_timer_timeout() -> void:
	inc_timer.start()


func _handle_inc_timer_timeout() -> void:
	if wager_inc_button_down:
		_inc_wager()
	elif wager_dec_button_down:
		_dec_wager()

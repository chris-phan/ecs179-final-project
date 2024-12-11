class_name MinigameUI
extends ColorRect

var wager_inc_button_down: bool = false
var wager_dec_button_down: bool = false
var minigame_manager: MinigameManager
var controls: Dictionary

@onready var wager: ColorRect = %Wager
@onready var game_name_label: Label = %GameName
@onready var minigame_image: TextureRect = %MinigameImg
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
@onready var move_left: HBoxContainer = %MoveLeft
@onready var move_right: HBoxContainer = %MoveRight
@onready var jump: HBoxContainer = %Jump
@onready var kick: HBoxContainer = %Kick
@onready var move_mouse: HBoxContainer = %MoveMouse

# Allows holding down increment/decrement buttons
# Starts continuously calling inc/dec wager after waiting hold_timer's wait_time
# Calls inc/dec wager after waiting for inc_timer's wait_time
@onready var hold_timer: Timer = $HoldTimer
@onready var inc_timer: Timer = $IncTimer


func _ready() -> void:
	tabs.tab_changed.connect(_handle_tab_changed)
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
	
	controls = {
		Minigame.Controls.MOVE_LEFT: move_left,
		Minigame.Controls.MOVE_RIGHT: move_right,
		Minigame.Controls.JUMP: jump,
		Minigame.Controls.KICK: kick,
		Minigame.Controls.MOVE_MOUSE: move_mouse,
	}


func remove_wager() -> void:
	wager.queue_free()


func set_minigame_manager(mm: MinigameManager) -> void:
	minigame_manager = mm


func set_game_name() -> void:
	game_name_label.text = minigame_manager.minigame_name


func set_minigame_img() -> void:
	minigame_image.texture = load(minigame_manager.minigame_img_path)


func set_instructions() -> void:
	instructions_label.text = minigame_manager.instructions


func set_initial_wager() -> void:
	wager_amount_label.text = str(minigame_manager.wager)


func set_initial_payout() -> void:
	payout_amount_label.text = str(minigame_manager.get_payout())


func set_tooltips() -> void:
	easy_button.tooltip_text = minigame_manager.easy_tooltip
	medium_button.tooltip_text = minigame_manager.medium_tooltip
	hard_button.tooltip_text = minigame_manager.hard_tooltip


func set_easy_button_focus() -> void:
	easy_button.grab_focus()


func set_difficulty() -> void:
	difficulty_value.text = Minigame.difficulty_name(minigame_manager.difficulty)


func set_controls() -> void:
	for control in controls:
		if control in minigame_manager.controls:
			controls[control].show()
		else:
			controls[control].hide()


func set_labels() -> void:
	set_game_name()
	set_minigame_img()
	set_instructions()
	set_initial_wager()
	set_initial_payout()
	set_tooltips()
	set_easy_button_focus()
	set_difficulty()
	set_controls()


func _inc_wager() -> void:
	wager_amount_label.text = str(minigame_manager.increase_wager())
	payout_amount_label.text = str(minigame_manager.get_payout())


func _dec_wager() -> void:
	wager_amount_label.text = str(minigame_manager.decrease_wager())
	payout_amount_label.text = str(minigame_manager.get_payout())


func _handle_tab_changed(_tab: int) -> void:
	sfx_player.play_button_press()
	if minigame_manager.minigame_name.contains("Boss"):
		tabs.current_tab = 0


func _handle_next_button_up() -> void:
	sfx_player.play_button_press()
	if minigame_manager.minigame_name.contains("Boss"):
		signal_bus.start_minigame.emit()
	else:
		tabs.current_tab = 1


func _handle_start_button_up() -> void:
	sfx_player.play_button_press()
	signal_bus.start_minigame.emit()


func _handle_easy_button_up() -> void:
	sfx_player.play_button_press()
	minigame_manager.difficulty = Minigame.Difficulty.EASY
	difficulty_value.text = "EASY"
	payout_amount_label.text = str(minigame_manager.get_payout())


func _handle_medium_button_up() -> void:
	sfx_player.play_button_press()
	minigame_manager.difficulty = Minigame.Difficulty.MEDIUM
	difficulty_value.text = "MEDIUM"
	payout_amount_label.text = str(minigame_manager.get_payout())


func _handle_hard_button_up() -> void:
	sfx_player.play_button_press()
	minigame_manager.difficulty = Minigame.Difficulty.HARD
	difficulty_value.text = "HARD"
	payout_amount_label.text = str(minigame_manager.get_payout())


func _handle_wager_inc_button_down() -> void:
	wager_inc_button_down = true
	hold_timer.start()


func _handle_wager_inc_button_up() -> void:
	sfx_player.play_button_press()
	wager_inc_button_down = false
	hold_timer.stop()
	inc_timer.stop()
	_inc_wager()


func _handle_wager_dec_button_down() -> void:
	wager_dec_button_down = true
	hold_timer.start()


func _handle_wager_dec_button_up() -> void:
	sfx_player.play_button_press()
	wager_dec_button_down = false
	hold_timer.stop()
	inc_timer.stop()
	_dec_wager()


func _handle_hold_timer_timeout() -> void:
	inc_timer.start()


func _handle_inc_timer_timeout() -> void:
	var cur_amount: int = int(wager_amount_label.text)
	if cur_amount != minigame_manager.old_balance and cur_amount != 0:
		sfx_player.play_money_counter()
	if wager_inc_button_down:
		_inc_wager()
	elif wager_dec_button_down:
		_dec_wager()

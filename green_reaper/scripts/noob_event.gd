class_name NoobEvent
extends Event

var encountered: bool
var _helped_noob: bool

func _init() -> void:
	super._init()
	encountered = false
	_max_step = 1
	_min = 0.4
	_max = 0.6
	_helped_noob = false


func start() -> void:
	super.start()
	event_name = "Noob"
	if not encountered:
		encountered = true
		event_body = "You encounter a Green Reaper noob who bet his life savings on beating the platform minigame on hard. He lost, as expected. Terrified of the Reaper, he begs you to loan him $%d so he can continue playing." % _random_stake
		op_1_text = "Pay $%d" % _random_stake
		op_2_text = "Leave"
	elif encountered and not _helped_noob:
		event_body = "The noob from earlier reveals that he himself is the Green Reaper, and that the earlier encounter was a test of character. He smites you as punishment for your greed."
		_payout = -0.95 * state_manager.cash
		_luck_diff = -10
		_switch_buttons()
		return
	else:
		event_body = "The noob from earlier managed to beat the game after hundreds of hours of playtime and is now a billionaire. He rewards you generously for helping him in his darkest hour."
		_payout = max(state_manager.cash, 100000)
		_luck_diff = 0.5
		_switch_buttons()
	


func select_option(option_num: int) -> void:
	if option_num == 1:
		event_body = "You give him $%d. The noob thanks you and continues on his way." % _random_stake
		_payout = -_random_stake
		_helped_noob = true

	else:
		event_body = "You scoff at his request and tell him to play better. The noob is silent for a moment, then abruptly stands up and leaves."
		_helped_noob = false

	super._inc_step()

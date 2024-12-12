class_name LotteryEvent
extends Event


func _init() -> void:
	super._init()
	_max_step = 21
	_min = 0.1
	_max = 0.3


func start() -> void:
	super.start()
	event_name = "Lottery"
	event_body = "Buy a lottery ticket? (Cost: %d)" % _random_stake

	op_1_text = "Buy"
	op_2_text = "Leave"


func select_option(option_num: int) -> void:
	if _cur_step < _max_step:

		if option_num == 1:
			_payout -= _random_stake

			# Check lottery win
			if randf() < state_manager.luck:
				event_body = "You won $%d." % (2 * _random_stake)
				_payout += 2 * _random_stake
			else:
				event_body = "You lost."

			# Check if enough money to continue playing
			if state_manager.cash + _payout < _random_stake:
				_switch_buttons()
				return

			op_1_text = "Buy another"

		else:
			event_body = "Bye."
			_switch_buttons()
			return

	super._inc_step()

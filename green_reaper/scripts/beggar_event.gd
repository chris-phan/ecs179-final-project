class_name BeggarEvent
extends Event


func _init() -> void:
	super._init()
	_max_step = 1
	event_name = "Beggar"
	event_body = "You come across a tired man sitting on the ground and carrying a sign. \"Spare some change?\", they ask."
	op_1_text = "Pay $%d" % _random_stake
	op_2_text = "Leave"


func select_option(option_num: int) -> void:
	if option_num == 1:
		event_body = "You give him $%d. You walk away with a smile and a lighter wallet." % _random_stake
		_payout = -_random_stake
		_luck_diff = _get_stake_proportion() * 0.6

	else:
		event_body = "Avoiding eye contact, you keep walking."
		_payout = 0

	super._inc_step()

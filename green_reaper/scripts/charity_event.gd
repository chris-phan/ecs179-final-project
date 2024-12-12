class_name CharityEvent
extends Event

func _init() -> void:
	super._init()
	_max_step = 1
	_min = 0.1
	_max = 0.5


func start() -> void:
	super.start()
	event_name = "Charity"
	event_body = "You come across a sign. It reads: The Charity (TM). Donate $%d to help us buy x cheeseburgers." % _random_stake

	op_1_text = "Donate $%d" % _random_stake
	op_2_text = "Ignore"


func select_option(option_num: int) -> void:
	if option_num == 1:
		event_body = "You're not sure why you donated. Maybe something possessed you."
		_payout = -_random_stake
		_luck_diff = _get_stake_proportion() * -0.5
	else:
		event_body = "How did they manage to get that trademarked?"

	super._inc_step()

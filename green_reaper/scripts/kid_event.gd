class_name KidEvent
extends Event

func _init() -> void:
	super._init()
	_max_step = 1
	event_name = "Kid"
	event_body = "You walk by a school and hear a bell. Kids start running outside towards an ice cream truck. One of these kids catches your attention. She's holding a $%d bill in her hand and is a slow runner." % _random_stake

	op_1_text = "Take her money"
	op_2_text = "Ignore"

func select_option(option_num: int) -> void:

	if option_num == 1:	
		event_body = "You tackle her and take her money. This was the easiest $%d you've ever made." % _random_stake
		_payout = _random_stake
		_luck_diff = _get_stake_proportion() * -0.5
	else:
		event_body = "You tackle her and take her money. This was the easiest $%d you've ever made." % _random_stake

	super._inc_step()


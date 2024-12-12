class_name KidEvent
extends Event


func _init() -> void:
	super._init()
	_max_step = 1
	_min = 0.05
	_max = 0.2

func start() -> void:
	super.start()
	event_name = "Kid"
	event_body = "You walk by a school and hear a bell. Kids start running outside towards an ice cream truck. One of these kids catches your attention. She's holding a $100 bill in her hand and is a slow runner."

	op_1_text = "Take her money"
	op_2_text = "Ignore"


func select_option(option_num: int) -> void:
	if option_num == 1:
		event_body = "You tackle her and take her money. This was the easiest $100 you've ever made."
		_payout = 100
		_luck_diff = -0.4
	else:
		if randf() < 0.5:
			event_body = "You're worried that she might beat you in a fight and run away with your head down. The cosmic forces around you mistake this as a good deed and reward you generously."
			_payout = 6 * _random_stake
			_luck_diff = 0.4
		else:
			event_body = "The kid senses weakness in you and steals $%d while your back is turned." % (2 * _random_stake)
			_payout = -2 * _random_stake
	
	super._inc_step()

class_name CarEvent
extends Event

func _init() -> void:
	super._init()
	_max_step = 1
	event_name = "Car"
	event_body = "You see the douchiest looking person you've ever seen: sunglasses, slick back hair, button up shirt with the top unbuttoned. You can clearly see his chest hair. He gets out of his $300,000 car, yells at a grandma, and walks into a store."

	op_1_text = "Key his car"
	op_2_text = "Ignore"

func select_option(option_num: int) -> void:

	if option_num == 1:	
		event_body = "You pull out your keys and start scratching his car. Someone in the backseat gets out of the car. They beat you up and take your money. What were you thinking?"
		_payout = -_random_stake
	else:
		event_body = "Sorry grandma, you're on your own."

	super._inc_step()


class_name WizardEvent
extends Event



func _init(cur_balance: int) -> void:
	super._init(cur_balance)
	_max_step = 2
	event_name = "Wizard"
	event_body = "You see a guy across the street ranting to himself about " \
	+ "how nobody in this city understands him and his magical powers. He's " \
	+ "holding a sign that says \"Fortune telling: $%d\"."  % _random_stake

	op_1_text = "Pay $%d" % _random_stake
	op_2_text = "Leave"

func select_option(option_num: int) -> void:
	if _cur_step == 0:
		if option_num == 1:
			event_body = "He says that in the future, someone will present you with an important choice: They will offer you $%d for nothing in return. Immediately after he says this, he tells you that he has the ability to create money from thin air. He reaches into his robe and pulls out a briefcase full of cash. There's $%d in there." % [4 * _random_stake, 4 * _random_stake]

			_payout -= _random_stake
			op_1_text = "Accept"
			op_2_text = "Decline"

		else:
			event_body = "Avoiding eye contact, you keep walking."

			_payout = 0
			_switch_buttons()
			return
	
	else:
		if option_num == 1:
			event_body = "Who would say no to $%d. The briefcase smells a little funny, but with $%d, your future is bright. " % [4 * _random_stake, 4 * _random_stake]
			
			_payout += 4 * _random_stake
		
		else:
			event_body = "You're not sure why you declined. Maybe something possessed you."
	
	super._inc_step()


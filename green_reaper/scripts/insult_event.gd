class_name InsultEvent
extends Event

var _insults: Array[String]

func _init() -> void:
	super._init()
	_max_step = 1
	_min = 0.7
	_max = 0.7
	_insults = ["Catcall them", "Shush them", "Headbutt them"]


func start() -> void:
	super.start()
	event_name = "Intrusive Thoughts"
	event_body = "You walk past someone on the street. You suddenly have an urge to do something terrible."
	op_1_text = _insults[randi() % _insults.size()]
	op_2_text = "Leave"


func select_option(option_num: int) -> void:
	if option_num == 1:
		event_body = "They beat you up and take most of your money. Other people on the street stand there and watch. They're laughing at you."
		_payout = -_random_stake

	else:
		event_body = "You're able to suppress your true feelings."
		_payout = 0

	super._inc_step()

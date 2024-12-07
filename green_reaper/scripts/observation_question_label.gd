class_name ObservationQuestionLabel
extends Label

@onready var target: ObservationTarget = $ObservationTarget


func _ready() -> void:
	target.disable()


func display(type: ObservationTarget.Type) -> void:
	target.set_type(type)
	#target.animation_player.play("move" + str(type))
	show()

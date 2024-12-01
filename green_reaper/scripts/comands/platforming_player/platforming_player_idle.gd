class_name PlatformingPlayerIdleCommand
extends Command


func execute(character: Character) -> Status:
	character.velocity.x = 0
	return Status.DONE

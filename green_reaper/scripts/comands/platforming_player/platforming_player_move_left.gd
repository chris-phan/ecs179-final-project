class_name PlatformingPlayerMoveLeftCommand
extends Command


func execute(character: Character) -> Status:
	character.velocity.x = -1 * character.movement_speed
	character.sprite.flip_h = true
	return Status.DONE

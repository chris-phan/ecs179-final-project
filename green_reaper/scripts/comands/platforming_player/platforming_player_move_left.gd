class_name PlatformingPlayerMoveLeftCommand
extends Command


func execute(character: Character) -> Status:
	character.velocity.x = -1 * character.movement_speed
	if character.sprite.scale.x > 0:
		character.sprite.scale.x *= -1
	return Status.DONE

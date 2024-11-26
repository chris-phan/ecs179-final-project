class_name PlatformingPlayerMoveRightCommand
extends Command


func execute(character: Character) -> Status:
	character.velocity.x = character.movement_speed
	character.sprite.flip_h = false
	return Status.DONE

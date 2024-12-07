class_name PlatformingPlayerMoveRightCommand
extends Command


func execute(character: Character) -> Status:
	sfx_player.play_character_move()
	character.velocity.x = character.movement_speed
	if character.sprite.scale.x < 0:
		character.sprite.scale.x *= -1
	return Status.DONE

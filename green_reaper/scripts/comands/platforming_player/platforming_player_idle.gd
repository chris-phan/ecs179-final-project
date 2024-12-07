class_name PlatformingPlayerIdleCommand
extends Command


func execute(character: Character) -> Status:
	sfx_player.stop_character_move()
	character.velocity.x = 0
	return Status.DONE

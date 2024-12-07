class_name PlatformingPlayerKickCommand
extends Command


func execute(character: Character) -> Status:
	sfx_player.stop_character_move()
	if character.is_on_floor():
		character.velocity.y += character.jump_velocity
		#character.command_callback("jump")
	
	return Status.DONE

class_name PlatformingPlayerJumpCommand
extends Command


func execute(character: Character) -> Status:
	if character.is_on_floor():
		character.velocity.y += character.jump_velocity
		#character.command_callback("jump")
	
	return Status.DONE

class_name SignalBus
extends Node


signal reached_platforming_goal
signal countdown_ended
signal hit_memory_object(color: MemoryObject.Colors)
signal hit_stop_timer_button
signal hit_observation_button(val: int)

# Used by MinigameManager to progress to next scene
# Board -> instructions & wager -> minigame -> result -> board
signal enter_minigame()
signal start_minigame()
signal end_minigame(did_player_win: bool)
signal exit_minigame()

# Intro signals
signal intro_done

# Event signals
signal enter_event()
signal end_event()
signal exit_event()

# Endgame signals
signal win_game
signal lose_game
signal reset_game
signal endgame_signal_received
signal space_ended_game

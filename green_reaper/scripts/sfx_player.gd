class_name SFXPlayer
extends Node2D

var called_upon_playback_pos: float
var orbit_playback_pos: float
var clean_living_playback_pos: float
var icelandic_arpeggios_playback_pos: float

@onready var button_press: AudioStreamPlayer2D = $ButtonPress
@onready var money_counter: AudioStreamPlayer2D = $MoneyCounter
@onready var show_result: AudioStreamPlayer2D = $ShowResult
@onready var countdown: AudioStreamPlayer2D = $Countdown
@onready var countdown_go: AudioStreamPlayer2D = $CountdownGo
@onready var heartbeat: AudioStreamPlayer2D = $Heartbeat
@onready var every_step: AudioStreamPlayer2D = $EveryStep
@onready var sunday_drive: AudioStreamPlayer2D = $SundayDrive
@onready var shadowing: AudioStreamPlayer2D = $Shadowing
@onready var character_move: AudioStreamPlayer2D = $CharacterMove
@onready var correct_observation: AudioStreamPlayer2D = $CorrectObservation
@onready var correct_memory: AudioStreamPlayer2D = $CorrectMemory
@onready var lucky: AudioStreamPlayer2D = $Lucky
@onready var board_positive: AudioStreamPlayer2D = $BoardPositive
@onready var board_negative: AudioStreamPlayer2D = $BoardNegative
@onready var board_move: AudioStreamPlayer2D = $BoardMove
@onready var dice_roll: AudioStreamPlayer2D = $DiceRoll
@onready var called_upon: AudioStreamPlayer2D = $CalledUpon
@onready var orbit: AudioStreamPlayer2D = $Orbit
@onready var clean_living: AudioStreamPlayer2D = $CleanLiving
@onready var icelandic_arpeggios: AudioStreamPlayer2D = $IcelandicArpeggios


func stop() -> void:
	every_step.stop()
	sunday_drive.stop()
	shadowing.stop()
	stop_called_upon()
	stop_orbit()
	stop_clean_living()
	stop_icelandic_arpeggios()


func play_button_press() -> void:
	button_press.play(0.16)


func play_money_counter() -> void:
	var new_money_counter = AudioStreamPlayer2D.new()
	new_money_counter.stream = load("res://assets/sounds/ui/money_counter.mp3")
	new_money_counter.finished.connect(func() -> void:
		new_money_counter.queue_free()
	)
	add_child(new_money_counter)
	new_money_counter.play()


func play_show_result() -> void:
	show_result.play()


func play_countdown() -> void:
	countdown.play()


func play_countdown_go() -> void:
	countdown_go.play()


func play_heartbeat() -> void:
	if not heartbeat.playing:
		# Randomize start and scale to make audio cues less effective in
		# the internal timer minigame
		heartbeat.play(randf_range(0, heartbeat.stream.get_length()))
		heartbeat.pitch_scale = randf_range(1, 2)


func stop_heartbeat() -> void:
	heartbeat.stop()


func play_every_step() -> void:
	every_step.play()


func stop_every_step() -> void:
	every_step.stop()


func play_sunday_drive() -> void:
	sunday_drive.play()


func stop_sunday_drive() -> void:
	sunday_drive.stop()


func play_shadowing() -> void:
	shadowing.play()


func stop_shadowing() -> void:
	shadowing.stop()


func play_character_move() -> void:
	if not character_move.playing:
		character_move.play()


func stop_character_move() -> void:
	character_move.stop()


func play_correct_observation() -> void:
	correct_observation.play()


func play_correct_memory() -> void:
	correct_memory.play()


func play_lucky() -> void:
	lucky.play()


func play_board_positive() -> void:
	board_positive.play()


func play_board_negative() -> void:
	board_negative.play()


func play_board_move() -> void:
	board_move.play()


func play_dice_roll() -> void:
	var new_dice_roll = AudioStreamPlayer2D.new()
	new_dice_roll.stream = load("res://assets/sounds/board/dice_roll.mp3")
	new_dice_roll.finished.connect(func() -> void:
		new_dice_roll.queue_free()
	)
	add_child(new_dice_roll)
	new_dice_roll.play()


func play_board_bgm() -> void:
	if state_manager.cash < 250000:
		play_called_upon()
	elif state_manager.cash < 500000:
		play_orbit()
	elif state_manager.cash < 750000:
		play_clean_living()
	else:
		play_icelandic_arpeggios()


func play_called_upon() -> void:
	if not called_upon.playing:
		called_upon.play(called_upon_playback_pos)


func stop_called_upon() -> void:
	called_upon_playback_pos = called_upon.get_playback_position() + AudioServer.get_time_since_last_mix()
	called_upon.stop()


func play_orbit() -> void:
	if not orbit.playing:
		orbit.play(orbit_playback_pos)


func stop_orbit() -> void:
	orbit_playback_pos = orbit.get_playback_position() + AudioServer.get_time_since_last_mix()
	orbit.stop()


func play_clean_living() -> void:
	if not clean_living.playing:
		clean_living.play(clean_living_playback_pos)


func stop_clean_living() -> void:
	clean_living_playback_pos = clean_living.get_playback_position() + AudioServer.get_time_since_last_mix()
	clean_living.stop()


func play_icelandic_arpeggios() -> void:
	if not icelandic_arpeggios.playing:
		icelandic_arpeggios.play(icelandic_arpeggios_playback_pos)


func stop_icelandic_arpeggios() -> void:
	icelandic_arpeggios_playback_pos = icelandic_arpeggios.get_playback_position() + AudioServer.get_time_since_last_mix()
	icelandic_arpeggios.stop()

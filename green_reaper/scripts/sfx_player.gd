class_name SFXPlayer
extends Node2D

#@onready var a: AudioStreamPlayer2D = $
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


func stop() -> void:
	show_result.stop()
	countdown.stop()
	countdown_go.stop()
	heartbeat.stop()
	every_step.stop()
	sunday_drive.stop()
	shadowing.stop()


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

class_name Intro
extends Node2D

@export var dialogue_wait: float = 5.0
@export var type_speed: float = 0.02

@onready var intro_dialogue: Label = $DialogueItems/IntroDialogue
@onready var skip_button: Button = $DialogueItems/SkipPanel/SkipButton
@onready var start_game_button: Button = $InfoItems/StartPanel/StartGameButton
@onready var intro_reaper: AnimatedSprite2D = $DialogueItems/IntroReaper
@onready var info_items: Control = $InfoItems
@onready var dialogue_items: Control = $DialogueItems


const TEXT_1: String = "Hey there! I'm the Green Reaper and I wanted to reach out to you about your life expiration! You have 20 days left in the world..."
const TEXT_2: String = "Usually, a Grim Reaper takes you butttt, I'm the GREEN one! If you can get me $1,000,000 before you expire, I'll extend your lifetime."
const TEXT_3: String = "Everyday, I'll teleport you to the gloomy world of mine where you'll have the opportunity to earn TONS OF MONEY!"
const TEXT_4: String = "Every 5 days I'll check if you're on track to get the million, and if you're not, I'll send my buddies to give you some encouragement!"
const TEXT_5: String = "If you run out of cash I'll have to take you early, so be careful! Good luck and get me that $1,000,000!"
const TEXTS: Array[String] = [TEXT_1, TEXT_2, TEXT_3, TEXT_4, TEXT_5]

var text_index: int 
var char_index: int
var text_delay_timer: Timer
var dialogues_finished: bool
var waiting_for_next_text: bool
var elapsed_time: float = 0.0

signal initial_dialog_done


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogues_finished = false
	waiting_for_next_text = false
	dialogue_items.visible = true
	info_items.visible = false
	intro_dialogue.text = ""
	text_index = 0
	char_index = 0
	connect("initial_dialog_done", show_info)
	skip_button.button_up.connect(_handle_skip_button)
	start_game_button.button_up.connect(_handle_start_button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not dialogues_finished:
		if not waiting_for_next_text:
			elapsed_time += delta
			if elapsed_time > type_speed:
				if char_index == len(TEXTS[text_index]):
					delay_for_next_text()
				else:
					intro_dialogue.text += TEXTS[text_index][char_index]
					char_index += 1
				elapsed_time = 0.0


func start_next_text() -> void:
	if text_index == len(TEXTS) - 1:
		emit_signal("initial_dialog_done")
		return
	
	text_index += 1
	char_index = 0
	intro_dialogue.text = ""


func delay_for_next_text() -> void:
	waiting_for_next_text = true
	text_delay_timer = Timer.new()
	add_child(text_delay_timer)
	text_delay_timer.wait_time = dialogue_wait
	text_delay_timer.one_shot = true
	text_delay_timer.start()
	
	await text_delay_timer.timeout
	waiting_for_next_text = false
	start_next_text()
	
	
func show_info() -> void:
	dialogues_finished = true
	dialogue_items.visible = false
	info_items.visible = true


func _handle_start_button() -> void:
	signal_bus.intro_done.emit()
	signal_bus.intro_done.emit()
	queue_free()
	

func _handle_skip_button() -> void:
	waiting_for_next_text = false
	
	if text_delay_timer != null:
		remove_child(text_delay_timer)
	
	start_next_text()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
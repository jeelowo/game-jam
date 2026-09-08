extends Node2D

const CHRISTIAN_DIALOGUE = preload("uid://cy1ge0cbbeau0")
@onready var rich_text_label: RichTextLabel = $Panel/VBoxContainer/RichTextLabel

var is_typing := false
@export var text_speed = 0.1

func _ready() -> void:
	start_dialogue(CHRISTIAN_DIALOGUE)

func _process(delta: float) -> void:
	if Input.is_action_pressed("speed up"):
		text_speed = 0.05
	elif Input.is_action_just_released("speed up"):
		text_speed = 0.1

func start_dialogue(dialogue: Dialogue):
	is_typing = true
	type_dialogue_line(dialogue)

func type_dialogue_line(dialogue: Dialogue):
	for letter in dialogue.lines[0].text:
		print(letter)
		if is_typing:
			rich_text_label.append_text(letter)
			# Skip whitespaces
			if letter != " ":
				await get_tree().create_timer(text_speed).timeout

	# runs when done typing
	is_typing = false
	print("done")

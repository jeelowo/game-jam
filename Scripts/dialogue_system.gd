extends Node2D

const CHRISTIAN_DIALOGUE = preload("uid://cy1ge0cbbeau0")
@onready var line_label: RichTextLabel = $"Line Panel/VBoxContainer/Line Label"
@onready var name_label: RichTextLabel = $"Name Panel/Name Label"

var is_typing := false
var line_num : int
var current_dialogue : Dialogue
@export var text_speed = 0.0767
var base_speed = text_speed
@export var speed_up_mult = 0.8

func _ready() -> void:
	start_dialogue(CHRISTIAN_DIALOGUE)
	line_num = 0

func _process(_delta: float) -> void:
	# speed up text when holding space ✅
	if Input.is_action_just_pressed("continue"):
		text_speed = base_speed * speed_up_mult
		print(text_speed)
	elif Input.is_action_just_released("continue"):
		text_speed = base_speed
		print(text_speed)

	# proceed to next dialogue line ✅
	if !is_typing and Input.is_action_just_pressed("continue") and line_num < current_dialogue.lines.size()-1:
		print(current_dialogue.lines.size())
		line_label.text = ""
		line_num += 1
		is_typing = true
		name_label.text = current_dialogue.lines[line_num].speaker
		type_dialogue_line(current_dialogue)
		print("next line")

# starts a the parameter dialogue ✅
func start_dialogue(dialogue: Dialogue):
	current_dialogue = dialogue
	is_typing = true
	name_label.text = current_dialogue.lines[line_num].speaker
	type_dialogue_line(current_dialogue)

# starts a the parameter dialogue ✅
func type_dialogue_line(dialogue: Dialogue):
	for i in dialogue.lines[line_num].text.length():
		var letter = dialogue.lines[line_num].text[i]

		if is_typing:
			line_label.append_text(letter)
			#print(letter)

			if letter == ".":
				if i == dialogue.lines[line_num].text.length() - 1:
					await get_tree().create_timer(text_speed * 2).timeout
				else:
					await get_tree().create_timer(text_speed * 14).timeout
			elif letter == "," or letter == "!":
				await get_tree().create_timer(text_speed * 7).timeout
			elif letter != " ":
				await get_tree().create_timer(text_speed).timeout

	# runs when done typing
	is_typing = false
	#print("done")

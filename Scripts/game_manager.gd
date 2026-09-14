extends Node2D
@onready var label: Label = $"../CanvasLayer/Label"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	label.visible = !label.visible

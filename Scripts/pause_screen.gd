extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
		print("pause")

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = !visible

func _on_resume_pressed() -> void:
	print("resume")
	toggle_pause()

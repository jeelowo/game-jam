extends Control

func _on_new_game_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_continue_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

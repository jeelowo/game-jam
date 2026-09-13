extends Area2D

@onready var pop_up: Node2D = $"Pop up"

func _on_body_entered(body: Node2D) -> void:
	pop_up.visible = true

func _on_body_exited(body: Node2D) -> void:
	pop_up.visible = false

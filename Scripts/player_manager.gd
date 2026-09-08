extends Node2D

@onready var flashlight: PointLight2D = $"../Flashlight"
@onready var walk: playerWalk = $"../State Machine/Walk"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("flashlight"):
		flashlight.enabled = !flashlight.enabled

	if flashlight.enabled:
		flashlight.rotation = walk.last_facing_direction.angle()

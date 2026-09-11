extends Node2D

@onready var flashlight: PointLight2D = $"../Flashlight"
@onready var walk: playerWalk = $"../State Machine/Walk"
@onready var player: CharacterBody2D = $".."
@onready var camera_2d: Camera2D = $"../Camera2D"

var camera_distance := 0.0
@export var max_camera_distance := 100.0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("flashlight"):
		flashlight.enabled = !flashlight.enabled

	if flashlight.enabled:
		flashlight.rotation = walk.last_facing_direction.angle()

	look_ahead(walk.last_facing_direction)

func look_ahead(direction):
	var camera_pos = player.global_position + (direction * max_camera_distance)
	var camera_direction = camera_2d.global_position.direction_to(camera_pos).normalized()
	camera_2d.global_position += camera_direction * float(sqrt(abs(camera_2d.global_position.distance_to(camera_pos)))/2)

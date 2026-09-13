extends Node2D

@onready var flashlight: PointLight2D = $"../Flashlight"
@onready var walk: playerWalk = $"../State Machine/Walk"
@onready var player: CharacterBody2D = $".."
@onready var camera_2d: Camera2D = $"../Camera2D"

var camera_distance := 0.0
@export var max_camera_distance := 100.0
var look_direction : Vector2

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("flashlight"):
		flashlight.enabled = !flashlight.enabled

	if flashlight.enabled:
		flashlight.rotation = walk.last_facing_direction.angle()

	if walk.last_facing_direction == Vector2.UP or Input.is_action_just_pressed("move_up"):
		look_direction = Vector2.UP
	elif walk.last_facing_direction == Vector2.DOWN or Input.is_action_just_pressed("move_down"):
		look_direction = Vector2.DOWN
	elif walk.last_facing_direction == Vector2.LEFT:
		look_direction = Vector2.LEFT
	elif walk.last_facing_direction == Vector2.RIGHT:
		look_direction = Vector2.RIGHT

	look_ahead(look_direction)

func look_ahead(direction):
	var camera_pos = player.global_position + (direction * max_camera_distance)
	var camera_direction = camera_2d.global_position.direction_to(camera_pos).normalized()
	camera_2d.global_position += camera_direction * float(sqrt(abs(camera_2d.global_position.distance_to(camera_pos)))/2)

func look_up_or_down():
	if Input.is_action_just_pressed("move_up"):
		look_direction = Vector2.UP
	elif Input.is_action_just_pressed("move_down"):
		look_direction = Vector2.DOWN

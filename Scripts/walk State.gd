extends State
class_name playerWalk

@onready var player: CharacterBody2D = $"../.."
@onready var player_sprite: AnimatedSprite2D = $"../../Player Sprite"

@export var move_speed := 50.0
var last_facing_direction := Vector2(0,0)
var direction : Vector2

func Enter():
	print("State: " + self.name)

func Physics_Update(delta: float):
	# player movement
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	player.velocity = direction * move_speed
	print(player.velocity)
	player.move_and_slide()

	# player face walk direction
	if direction == Vector2.UP:
		player_sprite.play("Walk Up")
		player_sprite.flip_h = false
	elif direction == Vector2.DOWN:
		player_sprite.play("Walk Down")
		player_sprite.flip_h = false
	elif direction == Vector2.LEFT:
		player_sprite.play("Walk Side")
		player_sprite.flip_h = false
	elif direction == Vector2.RIGHT:
		player_sprite.play("Walk Side")
		player_sprite.flip_h = true

	if direction != Vector2(0,0):
		last_facing_direction = direction

	# Transitions
	if direction == Vector2(0,0):
		Transitioned.emit(self, "Idle")

extends State
class_name playerIdle

@onready var walk: playerWalk = $"../Walk"
@onready var player_sprite: AnimatedSprite2D = $"../../Player Sprite"

func Enter():
	print("State: " + self.name)

	# player face to last walk direction
	if walk.last_facing_direction == Vector2.UP:
		player_sprite.play("Idle Up")
		player_sprite.flip_h = false
	elif walk.last_facing_direction == Vector2.DOWN:
		player_sprite.play("Idle Down")
		player_sprite.flip_h = false
	elif walk.last_facing_direction == Vector2.LEFT:
		player_sprite.play("Idle Side")
		player_sprite.flip_h = false
	elif walk.last_facing_direction == Vector2.RIGHT:
		player_sprite.play("Idle Side")
		player_sprite.flip_h = true

func Physics_Update(_delta: float):

	# Transitions
	if Input.get_vector("move_left","move_right","move_up","move_down") != Vector2(0,0):
		Transitioned.emit(self, "Walk")

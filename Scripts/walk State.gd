extends State
class_name playerWalk

@onready var player: CharacterBody2D = $"../.."

@export var move_speed := 50.0
var direction : Vector2

func Enter():
	print("State: " + self.name)

func Physics_Update(delta: float):
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	player.velocity = direction * delta * move_speed
	print(player.velocity)
	player.move_and_slide()

	# Transitions
	if direction == Vector2(0,0):
		Transitioned.emit(self, "Idle")

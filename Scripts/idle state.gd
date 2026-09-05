extends State
class_name playerIdle

func Enter():
	print("State: " + self.name)

func Physics_Update(_delta: float):


	# Transitions
	if Input.get_vector("move_left","move_right","move_up","move_down") != Vector2(0,0):
		Transitioned.emit(self, "Walk")

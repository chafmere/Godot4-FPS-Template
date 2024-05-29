extends StaticBody3D

@export var Health = 2

func Hit_Successful(damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	Health -= damage
	if Health <= 0:
		queue_free()

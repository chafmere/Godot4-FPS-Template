extends StaticBody3D

@export var Health = 2

func Hit_Successful(Damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	Health -= Damage
	if Health <= 0:
		queue_free()

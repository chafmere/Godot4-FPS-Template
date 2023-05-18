extends StaticBody3D

var Health = 1

func Hit_Successful(Damage, _Direction, _Position):
	Health -= Damage
	if Health <= 0:
		queue_free()

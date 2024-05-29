extends RigidBody3D

var Health = 999

func Hit_Successful(damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	var Hit_Position = _Position - get_global_transform().origin 
	Health -= damage
	if Health <= 0:
		queue_free()
		
	if _Direction != Vector3.ZERO:
		apply_impulse((_Direction*damage),Hit_Position)

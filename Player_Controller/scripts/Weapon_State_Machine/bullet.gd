extends RigidBody3D

var Damage: int = 0

func _on_body_entered(body):
	var _Direction = -get_global_transform().basis.z
	var _Position = get_global_transform().origin
	if body.is_in_group("Target") && body.has_method("Hit_Successful"):
		body.Hit_Successful(Damage,Vector3.ZERO, Vector3.ZERO)
		queue_free()

	queue_free()

func _on_timer_timeout():
	queue_free()



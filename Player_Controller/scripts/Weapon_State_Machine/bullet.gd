extends RigidBody3D

signal Hit_Successfull

var Damage: int = 0

func _on_body_entered(body):
	var _Direction = -get_global_transform().basis.z
	var _Position = get_global_transform().origin
	
	if body.is_in_group("Target") && body.has_method("Hit_Successful"):
		body.Hit_Successful(Damage,_Direction, _Position)
		queue_free()
		emit_signal("Hit_Successfull")

	queue_free()

func _on_timer_timeout():
	queue_free()


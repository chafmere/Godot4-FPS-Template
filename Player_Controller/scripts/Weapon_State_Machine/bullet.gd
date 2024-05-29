extends RigidBody3D

signal Hit_Successfull

var damage: int = 0

func _on_body_entered(body):
	if body.is_in_group("Target") && body.has_method("Hit_Successful"):
		body.Hit_Successful(damage)
		emit_signal("Hit_Successfull")

	queue_free()

func _on_timer_timeout():
	queue_free()

extends Node3D

var Damage: int = 0

signal Hit_Successfull

func _ready():
	$GPUParticles3D.set_emitting(true)
	$GPUParticles3D2.set_emitting(true)

func _on_body_entered(body):
	if body.is_in_group("Target") && body.has_method("Hit_Successful"):
		body.Hit_Successful(Damage)
		emit_signal("Hit_Successfull")


func _on_timer_timeout():
	queue_free()

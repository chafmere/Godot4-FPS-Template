extends Projectile

@export var explosion: ShapeCast3D

func _on_body_entered(_body, _proj, _norm):
	var collision_location: Vector3 = _proj.global_position
	explosion.global_position = collision_location
	
	explosion.force_shapecast_update()
	var targets = explosion.get_collision_count()
	
	for t in targets:
		var damage_target = explosion.get_collider(t)
		var damage_direction : Vector3 = (damage_target.global_position-collision_location ).normalized()
		var collision_point: Vector3 = explosion.get_collision_point(t)
		if damage_target.is_in_group("Target") && damage_target.has_method("Hit_Successful"):
			damage_target.Hit_Successful(damage, damage_direction,collision_point)
			Hit_Successfull.emit()
	
	_proj.queue_free()
	Projectiles_Spawned.erase(_proj)

	if Projectiles_Spawned.is_empty():
		queue_free()

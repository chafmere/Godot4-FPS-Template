extends Projectile

@export var explosion: ShapeCast3D

func _on_body_entered(_body, _proj, _norm):
	var collision_location: Vector3 = _proj.global_position
	explosion.global_position = collision_location
	
	explosion.force_shapecast_update()
	var targets = explosion.get_collision_count()
	
	for t in targets:
		var damage_target = explosion.get_collider(t)
		var collision_point: Vector3 = explosion.get_collision_point(t)
		var collision_normal: Vector3 = explosion.get_collision_normal(t)
		var hit_scan_array = [damage_target,collision_point,collision_normal]
		Hit_Scan_Collision(hit_scan_array,damage,collision_location)
	
	_proj.queue_free()
	Projectiles_Spawned.erase(_proj)

	if Projectiles_Spawned.is_empty():
		queue_free()

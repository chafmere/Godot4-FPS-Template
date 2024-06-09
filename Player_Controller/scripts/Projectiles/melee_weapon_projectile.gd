extends Projectile

@onready var melee_hitbox: ShapeCast3D = $MeleeHitbox

func _over_ride_collision(_camera_collision:Array, _damage: float):
	melee_hitbox.force_shapecast_update()
	var colliders = melee_hitbox.get_collision_count()
	for c in colliders:
		var Target = melee_hitbox.get_collider(c)
		if Target.is_in_group("Target") and Target.has_method("Hit_Successful"):
			Hit_Successfull.emit()
			var Direction = (Target.global_transform.origin - global_transform.origin).normalized()
			var Position =  melee_hitbox.get_collision_point(c)
			Target.Hit_Successful(_damage, Direction, Position)
	queue_free()

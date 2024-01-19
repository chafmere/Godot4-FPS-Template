extends Projectile

@export var Spread_Pattern: Path2D
@export_range(0.0,20.0) var randomness = 10.0
@export var Split_Damage: bool = false
var Spray_Vector

func _Set_Projectile(_Damage: int = 0,_Spray:Vector2 = Vector2.ZERO, _Range: int = 1000):
	randomize()
	
	Spray_Vector = Spread_Pattern.get_curve()
	
	Damage = _Damage/(max(Spray_Vector.get_point_count()*float(Split_Damage),1))
	
	for point in Spray_Vector.get_point_count():
		var SprayPoint = Spray_Vector.get_point_position(point)
		SprayPoint.x = SprayPoint.x + randf_range(-randomness,randomness)
		SprayPoint.y = SprayPoint.y + randf_range(-randomness,randomness)

		Fire_Projectile(SprayPoint,_Range,Rigid_Body_Projectile)

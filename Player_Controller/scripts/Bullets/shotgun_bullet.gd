extends Projectile

@export var Spread_Pattern: Path2D
@export_range(0.0,20.0) var randomness = 10.0
var Spray_Vector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Spray_Vector = Spread_Pattern.get_curve()
	print(Spray_Vector.get_point_count())
	return super._ready()

func _Set_Projectile(_Damage: int = 0,_Spray:Vector2 = Vector2.ZERO, _Range: int = 1000):
	Damage = _Damage
	
	Spray_Vector = Spread_Pattern.get_curve()
	for point in Spray_Vector.get_point_count():
		var SprayPoint = Spray_Vector.get_point_position(point)
		
		SprayPoint.x = SprayPoint.x + randf_range(-randomness,randomness)
		SprayPoint.y = SprayPoint.y + randf_range(-randomness,randomness)
		
		var pj = Rigid_Body_Projectile.instantiate()
		
		add_child(pj)
		pj.global_transform = global_transform
		Fire_Projectile(SprayPoint,_Range,pj)

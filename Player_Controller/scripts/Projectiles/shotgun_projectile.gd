extends Projectile

@onready var shotgun_pattern: Path2D = $shotgun_pattern
@export_range(0.0,20.0) var Randomness = 10.0
@export var Split_damage: bool = false
var Spray_Vector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Spray_Vector = shotgun_pattern.get_curve()
	return super._ready()

func _Set_Projectile(_damage: int = 0,_spread:Vector2 = Vector2.ZERO, _Range: int = 1000, origin_point: Vector3 = Vector3.ZERO):
	randomize()
	damage = _damage/(max(Spray_Vector.get_point_count()*float(Split_damage),1))
	
	for point in Spray_Vector.get_point_count():
		var SprayPoint:Vector2 = Spray_Vector.get_point_position(point)
		
		SprayPoint.x = SprayPoint.x + randf_range(-Randomness, Randomness)
		SprayPoint.y = SprayPoint.y + randf_range(-Randomness, Randomness)
		
		Fire_Projectile(SprayPoint,_Range,Rigid_Body_Projectile, origin_point)

extends Node
class_name Spray_Profile

@export var Spray_Noise: FastNoiseLite
@export var Spray_Path: Path2D
@export_range(0.0,1.0) var Spray_Mix: float  = 1.0
@export_range(0.0,10.0) var Random_Spray_Multiplier: float = 1.0
@export_range(0.0,10.0) var Path_Spray_Multiplier: float = 1.0

var Random_Spray: Vector2 = Vector2.ZERO
var Spray_Vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	print(Get_Spray(50))

func Get_Spray(count: int)->Vector2:
#	randomize()
	if Spray_Noise:
		Spray_Noise.set_seed(count)
		var x = Spray_Noise.get_noise_1d(count)*randi_range(1,count)
		var y = -abs(Spray_Noise.get_noise_1d(count+1)*randi_range(1,count))
		Random_Spray = Vector2(x,y)*Random_Spray_Multiplier

	if Spray_Path:
		var Path_Points: Curve2D = Spray_Path.get_curve()
		var Point_Count: int = Path_Points.get_point_count()
		count  = min(count,Point_Count-1)
		
		Spray_Vector = Path_Points.get_point_position(count)*Path_Spray_Multiplier
	
	var Spray = Spray_Vector + (Random_Spray*Spray_Mix)
	return Spray

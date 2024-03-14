extends Node
class_name Spray_Profile

@export_category("Random_Spray")
@export var Spray_Noise: FastNoiseLite
@export_range(0.0,10.0) var Random_Spray_Multiplier: float = 1.0
@export var Max_Limit: int = 30
@export var Updwards_Lock: bool = false
@export var True_Random: bool = true

@export_category("Path_Spray")
@export var Spray_Path: Path2D
@export_range(0.0,10.0) var Path_Spray_Multiplier: float = 1.0
@export_range(0.0,1.0) var Spray_Mix: float  = 1.0

var Random_Spray: Vector2 = Vector2.ZERO
var Spray_Vector: Vector2 = Vector2.ZERO

func Get_Spray(count: int,_max_count: int)->Vector2:
	if Spray_Noise:
		if True_Random:
			Spray_Noise.set_seed(randi())
			
		var x = Spray_Noise.get_noise_1d(count)*min(count,Max_Limit)
		var y = Spray_Noise.get_noise_2d(_max_count,count)*min(count,Max_Limit)
		
		if Updwards_Lock:
			y = -abs(y)
			
		Random_Spray = Vector2(x,y)*Random_Spray_Multiplier
		
	if Spray_Path:		
		var Path_Points: Curve2D = Spray_Path.get_curve()
		var Point_Count: int = Path_Points.get_point_count()
		count  = min(count-1,Point_Count-1)
		
		Spray_Vector = Path_Points.get_point_position(count)*Path_Spray_Multiplier

		
	var Spray = Spray_Vector + (Random_Spray*Spray_Mix)
	return Spray

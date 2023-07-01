@icon("res://Player_Controller/scripts/Weapon_State_Machine/weapon_resource_icon.svg")
extends Resource

class_name Weapon_Resource

@export_group("Weapon Animations")
@export var Weapon_Name: String
@export var Pick_Up_Anim: String
@export var Shoot_Anim: String
@export var Reload_Anim: String
@export var Change_Anim: String
@export var Drop_Anim: String
@export var Out_Of_Ammo_Anim: String

@export_group("Weapon Stats")
@export var Current_Ammo: int
@export var Reserve_Ammo: int
@export var Magazine: int
@export var Max_Ammo: int
@export var Damage: int
@export var AutoFire: bool

@export_group("Weapon Behaviour")
@export var Can_Be_Dropped: bool
@export var Weapon_Drop: PackedScene

@export_flags ("Hitscan", "Projectile") var Type = 1
@export var Projectile_To_Load: PackedScene
@export var Projectile_Velocity: int

@export_enum ("Spray_Random","Spray_Path") var Spray_Type: String = "Spray_Random"
@export var Spray_Path: PackedScene
@export var Random_Spray_Noise: Noise

@export_range(0,5) var Base_Magnetude = .1
@export_range(0,5) var x_Magnetude = .3
@export_range(0,5) var y_Magnetude = .3
@export_range(0,5) var z_Magnetude = .3

var Spray_Vector
var ShotCount = Current_Ammo
var count

func ready():
	if Spray_Path:
		var path =  Spray_Path.instantiate()
		Spray_Vector = path.get_curve()
		ShotCount = Magazine
	
func Get_Spray():
	count = ShotCount - Current_Ammo

	match Spray_Type:
		"Spray_Random":
			Random_Spray_Noise.set_seed(Current_Ammo)
			var x = Random_Spray_Noise.get_noise_2d(count,1)*count
			var y = Random_Spray_Noise.get_noise_2d(1,count)*count
			
			var Rand_Spray = Vector2(x,y)
			return Rand_Spray
			
		"Spray_Path":
			var Points = Spray_Vector.get_point_count()
			count = min(count,Points-1)
			
			return Spray_Vector.get_point_position(count)

func Spray_Count_Update():
	ShotCount = Current_Ammo

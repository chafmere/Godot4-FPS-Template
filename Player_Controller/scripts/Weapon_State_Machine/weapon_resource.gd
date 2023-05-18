extends Resource

class_name Weapon_Resource

@export var Weapon_Name: String
@export var Pick_Up_Anim: String
@export var Shoot_Anim: String
@export var Reload_Anim: String
@export var Change_Anim: String
@export var Drop_Anim: String
@export var Out_Of_Ammo_Anim: String

@export var Current_Ammo: int
@export var Reserve_Ammo: int
@export var Magazine: int
@export var Max_Ammo: int
@export var Damage: int

@export var AutoFire: bool

@export var Projectile_To_Load: PackedScene
@export var Projectile_Velocity: int
@export_flags ("Hitscan", "Projectile") var Type = 0

@export var Can_Be_Dropped: bool
@export var Weapon_Drop: PackedScene

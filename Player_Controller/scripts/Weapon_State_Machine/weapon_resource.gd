@icon("res://Player_Controller/scripts/Weapon_State_Machine/weapon_resource_icon.svg")
extends Resource

class_name Weapon_Resource

signal UpdateOverlay
signal Zoom

@export_group("Weapon Animations")
@export var Weapon_Name: String
@export var Pick_Up_Anim: String
@export var Shoot_Anim: String
@export var Reload_Anim: String
@export var Change_Anim: String
@export var Drop_Anim: String
@export var Out_Of_Ammo_Anim: String
@export var Melee_Anim: String

@export_group("Weapon Stats")
@export var Current_Ammo: int
@export var Reserve_Ammo: int
@export var Magazine: int
@export var Max_Ammo: int
@export var Damage: int
@export var Melee_Damage: float
@export var AutoFire: bool
@export var Fire_Range: int

@export_group("Weapon Behaviour")
@export var Can_Be_Dropped: bool
@export var Weapon_Drop: PackedScene
@export var Weapon_Spray: PackedScene
#@export_flags ("Hitscan", "Projectile") var Type = 1
@export var Projectile_To_Load: PackedScene
@export var Incremental_Reload: bool = false
#@export var Projectile_Velocity: int

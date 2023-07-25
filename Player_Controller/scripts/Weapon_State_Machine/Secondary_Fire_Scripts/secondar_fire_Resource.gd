extends Resource

class_name  secondary_fire_resource

@export var LoadOverlay: bool
@export var Overlay: Texture2D

@export var Zoom: bool
@export var Zoom_Amount: int

@export var ChangeSpray: bool
@export var NewSprayVector = Vector4()

@export var Seconday_Fire_Animation: String
@export var Seconday_Fire_Animation_Reset: String

@export var Secondary_Fire_Shoot: bool
@export_enum ("Hitscan", "Projectile") var Fire_Type:String = "Projectile"
@export var Ammo: int

@export var UpdateFlags: bool
@export var Flags: Dictionary

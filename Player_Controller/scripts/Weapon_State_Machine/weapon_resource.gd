@icon("res://Player_Controller/scripts/Weapon_State_Machine/weapon_resource_icon.svg")
extends Resource

class_name Weapon_Resource

signal UpdateOverlay
signal Zoom

@export_group("Weapon Animations")
##The Reference for the active weapons and pick ups
@export var Weapon_Name: String
## The Animation to play when the weapon was picked up
@export var Pick_Up_Anim: String
## The Animation to play when the weapon is shot
@export var Shoot_Anim: String
## The Animation to play when the weapon reload
@export var Reload_Anim: String
## The Animation to play when the weapon is Changed
@export var Change_Anim: String
## The Animation to play when the weapon is dropped
@export var Drop_Anim: String
## The Animation to play when the weapon is out of ammo
@export var Out_Of_Ammo_Anim: String
## The Animation to play when you do the melee strike
@export var Melee_Anim: String

@export_group("Weapon Stats")
## The Current Ammo of the weapon. Only needs a value if is a starting weapon. Otherwise is set on pick up.
@export var Current_Ammo: int
## The Amount in Reserve. Only needs a value if is a starting weapon. Otherwise is set on pick up.
@export var Reserve_Ammo: int
## The Maximum amount that you will reload if zero
@export var Magazine: int
## The Maximum ammo that can be held in reserve.
@export var Max_Ammo: int
## The Damage that a weapon will do
@export var Damage: int
## The Melee Damage that a weapon will do.
@export var Melee_Damage: float
## If Auto Fire is set to true the weapon will continuously fire until fire trigger is released
@export var AutoFire: bool
## The Range that a weapon will fire. Beyong this number no hit will trigger.
@export var Fire_Range: int

@export_group("Weapon Behaviour")
##If Checked the weapon drop scene MUST be provided
@export var Can_Be_Dropped: bool
## The Rigid body to spawn for the weapon. It should be a Rigid Body of type Weapon_Pick_Up and have a matching Weapon_Name.
@export var Weapon_Drop: PackedScene
## The Spray_Profile to use when firing the weapon. It should be of Type Spray_Profile. This handles the spray calculations and passes back the information to the Projectile to load
@export var Weapon_Spray: PackedScene
## The Projectile that will be loaded. Not a Rigid body but class that handles the ray cast processing and can be either hitscan or rigid body. Should be of Type Projectile
@export var Projectile_To_Load: PackedScene
## Incremental Reload is for shotgun or sigle item loaded weapons where you can interupt the reload process. If true the Calculate_Reload function on the weapon_state_machine must be called indepently. 
## For Example: at each step of a shotgun reload the function is called via the animation player.
@export var Incremental_Reload: bool = false


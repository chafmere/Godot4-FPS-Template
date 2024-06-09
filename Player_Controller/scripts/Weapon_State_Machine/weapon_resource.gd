@icon("res://Player_Controller/scripts/Weapon_State_Machine/weapon_resource_icon.svg")
extends Resource

class_name WeaponResource

signal update_overlay
signal Zoom

@export_group("Weapon Animations")
##The Reference for the active weapons and pick ups
@export var weapon_name: String
## The Animation to play when the weapon was picked up
@export var pick_up_animation: String
## The Animation to play when the weapon is shot
@export var shoot_animation: String
## The Animation to play when the weapon reload
@export var reload_animation: String
## The Animation to play when the weapon is Changed
@export var change_animation: String
## The Animation to play when the weapon is dropped
@export var drop_animation: String
## The Animation to play when the weapon is out of ammo
@export var out_of_ammo_animation: String
## The Animation to play when you do the melee strike
@export var melee_animation: String

@export_group("Weapon Stats")
## If Uncheck Shoot Function Will skip ammo check
@export var has_ammo: bool = true
## The Maximum amount that you will reload if zero
@export var magazine: int
## The Maximum ammo that can be held in reserve.
@export var max_ammo: int
## The damage that a weapon will do
@export var damage: int
## The Melee damage that a weapon will do.
@export var melee_damage: float
## If Auto Fire is set to true the weapon will continuously fire until fire trigger is released
@export var auto_fire: bool
## The Range that a weapon will fire. Beyong this number no hit will trigger.
@export var fire_range: int

@export_group("Weapon Behaviour")
##If Checked the weapon drop scene MUST be provided
@export var can_be_dropped: bool
## The Rigid body to spawn for the weapon. It should be a Rigid Body of type Weapon_Pick_Up and have a matching weapon_name.
@export var weapon_drop: PackedScene
## The Spray_Profile to use when firing the weapon. It should be of Type Spray_Profile. This handles the spray calculations and passes back the information to the Projectile to load
@export var weapon_spray: PackedScene
## The Projectile that will be loaded. Not a Rigid body but class that handles the ray cast processing and can be either hitscan or rigid body. Should be of Type Projectile
@export var projectile_to_load: PackedScene
## Incremental Reload is for shotgun or sigle item loaded weapons where you can interupt the reload process. If true the Calculate_Reload function on the weapon_state_machine must be called indepently. 
## For Example: at each step of a shotgun reload the function is called via the animation player.
@export var incremental_reload: bool = false


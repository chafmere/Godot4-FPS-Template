extends RigidBody3D

@export var _weapon_name: String
@export var _current_ammo: int
@export var _reserve_ammo: int

const TYPE = "Ammo"

var Pick_Up_Ready: bool = false

func _ready():
	await get_tree().create_timer(2.0).timeout
	Pick_Up_Ready = true

func Set_Ammo(w_name: String, c_ammo : int, r_ammo : int):
	if w_name == _weapon_name:
		_current_ammo = c_ammo
		_reserve_ammo = r_ammo

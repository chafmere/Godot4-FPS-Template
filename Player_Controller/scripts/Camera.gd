extends Node3D

@onready var MainCamera = get_node("%MainCamera")

@export var max_x := 15.0
@export var max_z := 20.0

@export_range (0.0,0.1)var Wind_Down = .05

signal camera_reset
signal start_shake

var tween
var BaseZoom: int

func _ready():
	BaseZoom = MainCamera.get_fov()

func Shake_Camera(Spray, x_mag, y_mag, z_mag, Magnetude):
	
	var x_rot = min(max(-Spray.y*y_mag,MainCamera.get_rotation_degrees().x),max_x)
	var y_rot = Spray.x*x_mag
	var z_rot = min(abs(Spray.x*z_mag),max_z)

	var Shake_Rotation = Vector3(x_rot,y_rot,z_rot)*Magnetude

	tween  = get_tree().create_tween().tween_property(MainCamera,"rotation_degrees",Shake_Rotation,.1)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(BounceBack)

func Reset_Camera():
	camera_reset.emit(MainCamera.get_rotation().x,MainCamera.get_rotation().y)
	
func Camera_Position_Tween_To_Zero():
	tween = get_tree().create_tween().tween_property(MainCamera,"rotation_degrees:x",0.0,.2)
	tween = get_tree().create_tween().tween_property(MainCamera,"rotation_degrees:y",0.0,.2)

func Camera_Position_To_Zero():
	MainCamera.rotation.x = 0
	MainCamera.rotation.y = 0

func _on_weapons_manager_spray_rotation(Spray_Rotation, x_mag, y_mag, z_mag, Magnetude, count):
	if count == 1:
		start_shake.emit()
		
	Shake_Camera(Spray_Rotation, x_mag, y_mag, z_mag, Magnetude)

func _on_weapons_manager_reset_spray():
	Reset_Camera()

func BounceBack():
	var z_rot = -MainCamera.get_rotation_degrees().z/2
	
	if is_zero_approx(z_rot):
		return

	tween = get_tree().create_tween().tween_property(MainCamera,"rotation_degrees:z",z_rot,Wind_Down)

	tween.set_trans(Tween.TRANS_LINEAR)
	tween.finished.connect(BounceBack)

func ZoomCamera(amt:int = 0):
	var Zoom = BaseZoom-amt

	var zoom_tween = get_tree().create_tween().tween_property(MainCamera,"fov",Zoom,.1)
	zoom_tween.set_trans(Tween.TRANS_LINEAR)

func _on_weapons_manager_connect_weapon_to_camera(weapon: Weapon_Resource):
	weapon.Zoom.connect(ZoomCamera)

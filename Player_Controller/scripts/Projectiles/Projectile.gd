extends Node3D
class_name Projectile

signal Hit_Successfull

@export_enum ("Hitscan","Rigidbody_Projectile") var Projectile_Type: String = "Hitscan"
@export var Projectile_Velocity: int
@export var Expirey_Time: int = 10
@export var Display_Debug_Decal: bool = true
@export var Rigid_Body_Projectile: PackedScene

@onready var Debug_Bullet = preload("res://Player_Controller/Spawnable_Objects/hit_debug.tscn")

var Damage: float = 0
var Projectiles_Spawned = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(Expirey_Time).timeout.connect(_on_timer_timeout)

func _Set_Projectile(_Damage: int = 0,_spread:Vector2 = Vector2.ZERO, _Range: int = 1000):
	Damage = _Damage
	Fire_Projectile(_spread,_Range,Rigid_Body_Projectile)

func Fire_Projectile(_spread,_range, _proj):
	var Camera_Collision = Camera_Ray_Cast(_spread,_range)
	
	match Projectile_Type:
		"Hitscan":
			Hit_Scan_Collision(Camera_Collision, Damage)
		"Rigidbody_Projectile":
			Launch_Rigid_Body_Projectile(Camera_Collision, _proj)

func Camera_Ray_Cast(_spread: Vector2 = Vector2.ZERO, _range: float = 1000):
	var _Camera = get_viewport().get_camera_3d()
	var _Viewport = get_viewport().size
	
	var Ray_Origin = _Camera.project_ray_origin((_Viewport/2))
	var Ray_End = (Ray_Origin + _Camera.project_ray_normal((_Viewport/2)+Vector2i(_spread))*_range)
	var New_Intersection = PhysicsRayQueryParameters3D.create(Ray_Origin,Ray_End)
	New_Intersection.set_collision_mask(0b11101111)
	
	var Intersection = get_world_3d().direct_space_state.intersect_ray(New_Intersection)
	
	if not Intersection.is_empty():
		var Collision = [Intersection.collider,Intersection.position,Intersection.normal]
		return Collision
	else:
		return [null,Ray_End,null]

func Hit_Scan_Collision(Collision: Array,_damage):
	var Point = Collision[1]
	var Bullet_Point = get_parent()
	
	if Collision[0]:
		Load_Decal(Point, Collision[2])
		
		if Collision[0].is_in_group("Target"):
			var Bullet = get_world_3d().direct_space_state

			var Bullet_Direction = (Point - Bullet_Point.global_transform.origin).normalized()
			var New_Intersection = PhysicsRayQueryParameters3D.create(Bullet_Point.global_transform.origin,Point+Bullet_Direction*2)

			var Bullet_Collision = Bullet.intersect_ray(New_Intersection)

			if Bullet_Collision:
				Hit_Scan_Damage(Bullet_Collision.collider, Bullet_Direction,Bullet_Collision.position,_damage)

func Hit_Scan_Damage(Collider, Direction, Position, _damage):
	if Collider.is_in_group("Target") and Collider.has_method("Hit_Successful"):
		Hit_Successfull.emit()
		Collider.Hit_Successful(_damage, Direction, Position)
		queue_free()

func Load_Decal(_pos,_normal):
	if Display_Debug_Decal:
		var rd = Debug_Bullet.instantiate()
		var world = get_tree().get_root()
		world.add_child(rd)
		rd.global_translate(_pos+(_normal*.01))
		
		
func Launch_Rigid_Body_Projectile(Collision_Data, _projectile):
	var _Point = Collision_Data[1]
	var _Norm = Collision_Data[2]
	var _proj = _projectile.instantiate()
	add_child(_proj)
	
	Projectiles_Spawned.push_back(_proj)

	_proj.body_entered.connect(_on_body_entered.bind(_proj,_Norm))
	
	var _Direction = (_Point - global_transform.origin).normalized()
	_proj.set_as_top_level(true)
	_proj.set_linear_velocity(_Direction*Projectile_Velocity)

func _on_body_entered(body, _proj, _norm):
	if body.is_in_group("Target") && body.has_method("Hit_Successful"):
		body.Hit_Successful(Damage)
		Hit_Successfull.emit()

	Load_Decal(_proj.get_position(),_norm)
	_proj.queue_free()
		
	Projectiles_Spawned.erase(_proj)
	
	if Projectiles_Spawned.is_empty():
		queue_free()

func _on_timer_timeout():
	queue_free()

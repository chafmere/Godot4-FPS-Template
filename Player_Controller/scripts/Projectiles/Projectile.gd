extends Node3D
class_name Projectile

signal Hit_Successfull

## Can Be Either A Hit Scan or Rigid Body Projectile. If Rigid body is select a Rigid body must be provided.
@export_enum ("Hitscan","Rigidbody_Projectile","over_ride") var Projectile_Type: String = "Hitscan"
@export var Display_Debug_Decal: bool = true

@export_category("Rigid Body Projectile Properties")
@export var Projectile_Velocity: int
@export var Expirey_Time: int = 10
@export var Rigid_Body_Projectile: PackedScene
@export var pass_through: bool = false

@onready var Debug_Bullet = preload("res://Player_Controller/Spawnable_Objects/hit_debug.tscn")

var damage: float = 0
var Projectiles_Spawned = []
var hit_objects: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(Expirey_Time).timeout.connect(_on_timer_timeout)

func _Set_Projectile(_damage: int = 0,_spread:Vector2 = Vector2.ZERO, _Range: int = 1000, origin_point: Vector3 = Vector3.ZERO):
	damage = _damage
	Fire_Projectile(_spread,_Range,Rigid_Body_Projectile, origin_point)

func Fire_Projectile(_spread: Vector2 ,_range: int, _proj:PackedScene, origin_point: Vector3):
	var Camera_Collision = Camera_Ray_Cast(_spread,_range)
	
	match Projectile_Type:
		"Hitscan":
			Hit_Scan_Collision(Camera_Collision, damage,origin_point)
		"Rigidbody_Projectile":
			Launch_Rigid_Body_Projectile(Camera_Collision, _proj)
		"over_ride":
			_over_ride_collision(Camera_Collision, damage)

func _over_ride_collision(_camera_collision:Array, _damage: float) -> void:
	pass

func Camera_Ray_Cast(_spread: Vector2 = Vector2.ZERO, _range: float = 1000):
	var _Camera = get_viewport().get_camera_3d()
	var _Viewport = get_viewport().get_size()
	
	var Ray_Origin = _Camera.project_ray_origin(_Viewport/2)
	var Ray_End = (Ray_Origin + _Camera.project_ray_normal((_Viewport/2)+Vector2i(_spread))*_range)
	var New_Intersection:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(Ray_Origin,Ray_End)
	New_Intersection.set_collision_mask(0b11101111)
	New_Intersection.set_hit_from_inside(false) # In Jolt this is set to true by defualt
	
	var Intersection = get_world_3d().direct_space_state.intersect_ray(New_Intersection)
	
	if not Intersection.is_empty():
		var Collision = [Intersection.collider,Intersection.position,Intersection.normal]
		return Collision
	else:
		return [null,Ray_End,null]

func Hit_Scan_Collision(Collision: Array,_damage: float, origin_point: Vector3):
	var Point = Collision[1]
	print(_damage)
	if Collision[0]:
		Load_Decal(Point, Collision[2])
		
		if Collision[0].is_in_group("Target"):
			var Bullet = get_world_3d().direct_space_state

			var Bullet_Direction = (Point - origin_point).normalized()
			var New_Intersection = PhysicsRayQueryParameters3D.create(origin_point,Point+Bullet_Direction*2)
			New_Intersection.set_collision_mask(0b11101111)
			New_Intersection.set_hit_from_inside(false)
			New_Intersection.set_exclude(hit_objects)
			var Bullet_Collision = Bullet.intersect_ray(New_Intersection)
	
			if Bullet_Collision:
				Hit_Scan_damage(Bullet_Collision.collider, Bullet_Direction,Bullet_Collision.position,_damage)
				if pass_through and check_pass_through(Bullet_Collision.collider, Bullet_Collision.rid):
					var pass_through_collision : Array = [Bullet_Collision.collider, Bullet_Collision.position, Bullet_Collision.normal]
					var pass_through_damage: float = damage/2
					#print(pass_through_damage)
					Hit_Scan_Collision(pass_through_collision,pass_through_damage,Bullet_Collision.position)
					return
			queue_free()

func check_pass_through(collider: Node3D, rid: RID)-> bool:
	var valid_pass_though: bool = false
	if collider.is_in_group("Pass Through"):
		hit_objects.append(rid)
		valid_pass_though = true
	return valid_pass_though

func Hit_Scan_damage(Collider, Direction, Position, _damage):
	if Collider.is_in_group("Target") and Collider.has_method("Hit_Successful"):
		Hit_Successfull.emit()
		Collider.Hit_Successful(_damage, Direction, Position)


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
		body.Hit_Successful(damage)
		Hit_Successfull.emit()

	Load_Decal(_proj.get_position(),_norm)
	_proj.queue_free()
		
	Projectiles_Spawned.erase(_proj)
	
	if Projectiles_Spawned.is_empty():
		queue_free()

func _on_timer_timeout():
	queue_free()

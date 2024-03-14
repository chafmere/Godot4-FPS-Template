extends Node3D

signal Weapon_Changed
signal Update_Ammo
signal Update_WeaponStack
signal Hit_Successfull
signal Add_Signal_To_HUD

signal Connect_Weapon_To_HUD

@export var Animation_Player: AnimationPlayer
@export var Melee_Hitbox: ShapeCast3D
@onready var Bullet_Point = get_node("%BulletPoint")
@onready var Debug_Bullet = preload("res://Player_Controller/Spawnable_Objects/hit_debug.tscn")

var Melee_Shake:= Vector3(0,0,2.5)
var Melee_Shake_Magnetude:= Vector4(1,1,1,1)

var Current_Weapon: Weapon_Resource = null

var WeaponStack:Array = [] #An Array of weapons currently in possesion by the player
var Next_Weapon: String

#The List of All Available weapons in the game
var Weapons_List: Dictionary = {}

#Spray Profiles For Each Weapon
var Spray_Profiles: Dictionary = {}
var _count = 0
var shot_tween
#An Array of weapon resources to make dictionary creation easier
@export var _weapon_resources: Array[Weapon_Resource]

@export var Start_Weapons: Array[String]

func _ready():
	Animation_Player.animation_finished.connect(_on_animation_finished)
	Initialize(Start_Weapons) #current starts on the first weapon in the stack

func _input(event):
	if event.is_action_pressed("WeaponUp"):
		var GetRef = WeaponStack.find(Current_Weapon.Weapon_Name)
		GetRef = min(GetRef+1,WeaponStack.size()-1)
		
		exit(WeaponStack[GetRef])

	if event.is_action_pressed("WeaponDown"):
		var GetRef = WeaponStack.find(Current_Weapon.Weapon_Name)
		GetRef = max(GetRef-1,0)

		exit(WeaponStack[GetRef])

	if event.is_action_pressed("Shoot"):
		shoot()
	
	if event.is_action_released("Shoot"):
		Shot_Count_Update()
	
	if event.is_action_pressed("Reload"):
		reload()

	if event.is_action_pressed("Drop_Weapon"):
		drop(Current_Weapon.Weapon_Name)
		
	if event.is_action_pressed("Melee"):
		melee()
		
func Initialize(_Start_Weapons: Array):
	for Weapons in _weapon_resources:
		Weapons_List[Weapons.Weapon_Name] = Weapons
		
		if Weapons.Weapon_Spray:
			Spray_Profiles[Weapons.Weapon_Name] = Weapons.Weapon_Spray.instantiate()
			
		Connect_Weapon_To_HUD.emit(Weapons)
		
	for weapon_name in _Start_Weapons:
		WeaponStack.push_back(weapon_name)

	Current_Weapon = Weapons_List[WeaponStack[0]]

	Update_WeaponStack.emit(WeaponStack)
	enter()

func enter():
	Animation_Player.queue(Current_Weapon.Pick_Up_Anim)
	Weapon_Changed.emit(Current_Weapon.Weapon_Name)
	Update_Ammo.emit([Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])

func exit(_next_weapon: String):
	if _next_weapon != Current_Weapon.Weapon_Name:
		if Animation_Player.get_current_animation() != Current_Weapon.Change_Anim:
			Animation_Player.queue(Current_Weapon.Change_Anim)
			Next_Weapon = _next_weapon

func Change_Weapon(weapon_name: String):
	Current_Weapon = Weapons_List[weapon_name]
	Next_Weapon = ""
	enter()
	
func Shot_Count_Update():
	shot_tween = get_tree().create_tween()
	shot_tween.tween_property(self,"_count",0,1)
	
func shoot():
	if Current_Weapon.Current_Ammo != 0:
		if Current_Weapon.Incremental_Reload and Animation_Player.current_animation == Current_Weapon.Reload_Anim:
			Animation_Player.stop()
			
		if not Animation_Player.is_playing():
			Animation_Player.play(Current_Weapon.Shoot_Anim)
			Current_Weapon.Current_Ammo -= 1
			Update_Ammo.emit([Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])
			
			if shot_tween:
				shot_tween.kill()
			
			var Spread = Vector2.ZERO
			
			if Current_Weapon.Weapon_Spray:
				_count = _count + 1
				Spread = Spray_Profiles[Current_Weapon.Weapon_Name].Get_Spray(_count, Current_Weapon.Magazine)
				
			Load_Projectile(Spread)
	else:
		reload()
		
func Load_Projectile(_spread):
	var _projectile:Projectile = Current_Weapon.Projectile_To_Load.instantiate()
	Bullet_Point.add_child(_projectile)
	Add_Signal_To_HUD.emit(_projectile)
	_projectile._Set_Projectile(Current_Weapon.Damage,_spread,Current_Weapon.Fire_Range)

func reload():
	if Current_Weapon.Current_Ammo == Current_Weapon.Magazine:
		return
	elif not Animation_Player.is_playing():
		
		if Current_Weapon.Reserve_Ammo != 0:		
				
			Animation_Player.queue(Current_Weapon.Reload_Anim)

		else:
			Animation_Player.queue(Current_Weapon.Out_Of_Ammo_Anim)

func Calculate_Reload():
	if Current_Weapon.Current_Ammo == Current_Weapon.Magazine:
		var anim_legnth = Animation_Player.get_current_animation_length()
		Animation_Player.advance(anim_legnth)
		return
		
	var Mag_Amount = Current_Weapon.Magazine
	
	if Current_Weapon.Incremental_Reload:
		Mag_Amount = Current_Weapon.Current_Ammo+1
		
	var Reload_Amount = min(Mag_Amount-Current_Weapon.Current_Ammo,Mag_Amount,Current_Weapon.Reserve_Ammo)
	
	Current_Weapon.Current_Ammo = Current_Weapon.Current_Ammo+Reload_Amount
	Current_Weapon.Reserve_Ammo = Current_Weapon.Reserve_Ammo-Reload_Amount
	
	Update_Ammo.emit([Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])
	Shot_Count_Update()

func melee():
	var Current_Anim = Animation_Player.get_current_animation()
	
	if Current_Anim == Current_Weapon.Shoot_Anim:
		return
		
	if Current_Anim != Current_Weapon.Melee_Anim:
		Animation_Player.play(Current_Weapon.Melee_Anim)
		if Melee_Hitbox.is_colliding():
			var colliders = Melee_Hitbox.get_collision_count()
			for c in colliders:
				var Target = Melee_Hitbox.get_collider(c)
				if Target.is_in_group("Target") and Target.has_method("Hit_Successful"):
					Hit_Successfull.emit()
					var Direction = (Target.global_transform.origin - owner.global_transform.origin).normalized()
					var Position =  Melee_Hitbox.get_collision_point(c)
					Target.Hit_Successful(Current_Weapon.Melee_Damage, Direction, Position)
			
func drop(_name: String):
	if Weapons_List[_name].Can_Be_Dropped and WeaponStack.size() != 1:
		var Weapon_Ref = WeaponStack.find(_name,0)
		if Weapon_Ref != -1:
			WeaponStack.pop_at(Weapon_Ref)
			Update_WeaponStack.emit(WeaponStack)

			if Weapons_List[_name].Weapon_Drop:
				var Weapon_Dropped = Weapons_List[_name].Weapon_Drop.instantiate()
				Weapon_Dropped._current_ammo = Weapons_List[_name].Current_Ammo
				Weapon_Dropped._reserve_ammo = Weapons_List[_name].Reserve_Ammo

				Weapon_Dropped.set_global_transform(Bullet_Point.get_global_transform())
				get_tree().get_root().add_child(Weapon_Dropped)

				Animation_Player.play(Current_Weapon.Drop_Anim)
				Weapon_Ref  = max(Weapon_Ref-1,0)
				exit(WeaponStack[Weapon_Ref])
	else:
		return
		
func _on_animation_finished(anim_name):
	if anim_name == Current_Weapon.Shoot_Anim:
		if Current_Weapon.AutoFire == true:
				if Input.is_action_pressed("Shoot"):
					shoot()

	if anim_name == Current_Weapon.Change_Anim:
		Change_Weapon(Next_Weapon)
	
	if anim_name == Current_Weapon.Reload_Anim:
		if !Current_Weapon.Incremental_Reload:
			Calculate_Reload()


func _on_pick_up_detection_body_entered(body):
	var Weapon_In_Stack = WeaponStack.find(body._weapon_name,0)
	
	if Weapon_In_Stack != -1:
		var remaining

		remaining = Add_Ammo(body._weapon_name, body._current_ammo+body._reserve_ammo)
		body._current_ammo = min(remaining, Weapons_List[body._weapon_name].Magazine)
		body._reserve_ammo = max(remaining - body._current_ammo,0)

		if remaining == 0:
			body.queue_free()
		
	elif body.TYPE == "Weapon":
		if body.Pick_Up_Ready == true:
			var GetRef = WeaponStack.find(Current_Weapon.Weapon_Name)
			WeaponStack.insert(GetRef,body._weapon_name)

			#Zero Out Ammo From the Resource
			Weapons_List[body._weapon_name].Current_Ammo = body._current_ammo
			Weapons_List[body._weapon_name].Reserve_Ammo = body._reserve_ammo

			Update_WeaponStack.emit(WeaponStack)
			exit(body._weapon_name)

			body.queue_free()

func Add_Ammo(_Weapon: String, Ammo: int)->int:
	var _weapon = Weapons_List[_Weapon]

	var Required = _weapon.Max_Ammo - _weapon.Reserve_Ammo
	var Remaining = max(Ammo - Required,0)

	_weapon.Reserve_Ammo += min(Ammo, Required)

	Update_Ammo.emit([Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo])
	return Remaining

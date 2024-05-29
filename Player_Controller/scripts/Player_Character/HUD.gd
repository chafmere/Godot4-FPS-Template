extends CanvasLayer

@onready var current_weapon_label = $debug_hud/HBoxContainer/CurrentWeapon
@onready var current_ammo_label = $debug_hud/HBoxContainer2/CurrentAmmo
@onready var current_weapon_stack = $debug_hud/HBoxContainer3/WeaponStack
@onready var hit_sight = $HitSight
@onready var hit_sight_timer = $HitSight/HitSightTimer
@onready var overLay = $Overlay

func _on_weapons_manager_update_weapon_stack(WeaponStack):
	current_weapon_stack.text = ""
	for i in WeaponStack:
		current_weapon_stack.text += "\n"+i.weapon.weapon_name

func _on_weapons_manager_update_ammo(Ammo):
	current_ammo_label.set_text(str(Ammo[0])+" / "+str(Ammo[1]))

func _on_weapons_manager_weapon_changed(WeaponName):
	current_weapon_label.set_text(WeaponName)

func _on_hit_sight_timer_timeout():
	hit_sight.set_visible(false)

func _on_weapons_manager_add_signal_to_hud(_projectile):
	_projectile.Hit_Successfull.connect(_on_weapons_manager_hit_successfull)

func _on_weapons_manager_hit_successfull():
	hit_sight.set_visible(true)
	hit_sight_timer.start()

func load_over_lay_texture(Active:bool, txtr: Texture2D = null):
		overLay.set_texture(txtr)
		overLay.set_visible(Active)

func _on_weapons_manager_connect_weapon_to_hud(_weapon_resouce: WeaponResource):
	_weapon_resouce.update_overlay.connect(load_over_lay_texture)



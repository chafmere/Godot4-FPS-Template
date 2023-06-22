extends CanvasLayer

@onready var Debug_HUD = $debug_hud
@onready var CurrentWeaponLabel = $debug_hud/HBoxContainer/CurrentWeapon
@onready var CurrentAmmoLabel = $debug_hud/HBoxContainer2/CurrentAmmo
@onready var CurrentWeaponStack = $debug_hud/HBoxContainer3/WeaponStack
@onready var CurrentFOV = $"debug_hud/HBoxContainer4/FOV Label"
@onready var Hit_Sight = $Hit_Sight
@onready var Hit_Sight_Timer = $Hit_Sight/Hit_Sight_Timer
@onready var FOVSlider = $debug_hud/FOV

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if FOVSlider:
			FOVSlider.release_focus()

func _on_weapons_manager_update_weapon_stack(WeaponStack):
	CurrentWeaponStack.text = ""
	for i in WeaponStack:
		CurrentWeaponStack.text += "\n"+i

func _on_weapons_manager_update_ammo(Ammo):
	CurrentAmmoLabel.set_text(str(Ammo[0])+" / "+str(Ammo[1]))

func _on_weapons_manager_weapon_changed(WeaponName):
	CurrentWeaponLabel.set_text(WeaponName)

func _on_hit_sight_timer_timeout():
	Hit_Sight.set_visible(false)

func _on_weapons_manager_add_signal_to_hud(_projectile):
	_projectile.connect("Hit_Successfull", Callable(self,"_on_weapons_manager_hit_successfull"))

func _on_weapons_manager_hit_successfull():
	Hit_Sight.set_visible(true)
	Hit_Sight_Timer.start()

func _on_weapons_models_update_fov(Fov, UpdateSlider: bool = false):
	CurrentFOV.set_text(str(Fov))
	if UpdateSlider:
		FOVSlider.set_value_no_signal(Fov)

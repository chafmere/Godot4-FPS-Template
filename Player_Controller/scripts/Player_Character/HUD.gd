extends CanvasLayer

@onready var Debug_HUD = $debug_hud
@onready var CurrentWeaponLabel = $debug_hud/HBoxContainer/CurrentWeapon
@onready var CurrentAmmoLabel = $debug_hud/HBoxContainer2/CurrentAmmo
@onready var CurrentWeaponStack = $debug_hud/HBoxContainer3/WeaponStack


func _on_weapons_weapon_changed(WeaponName):
	CurrentWeaponLabel.set_text(WeaponName)


func _on_weapons_manager_update_weapon_stack(WeaponStack):
	CurrentWeaponStack.text = ""
	for i in WeaponStack:
		CurrentWeaponStack.text += "\n"+i


func _on_weapons_manager_update_ammo(Ammo):
	CurrentAmmoLabel.set_text(str(Ammo[0])+" / "+str(Ammo[1]))


func _on_weapons_manager_weapon_changed(WeaponName):
	CurrentWeaponLabel.set_text(WeaponName)


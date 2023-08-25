extends CanvasLayer

@onready var Debug_HUD = $debug_hud
@onready var CurrentWeaponLabel = $debug_hud/HBoxContainer/CurrentWeapon
@onready var CurrentAmmoLabel = $debug_hud/HBoxContainer2/CurrentAmmo
@onready var CurrentWeaponStack = $debug_hud/HBoxContainer3/WeaponStack
@onready var Hit_Sight = $Hit_Sight
@onready var Hit_Sight_Timer = $Hit_Sight/Hit_Sight_Timer
@onready var OverLay = $Overlay

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


func LoadOverLayTexture(Active:bool, txtr: Texture2D = null):
		OverLay.set_texture(txtr)
		OverLay.set_visible(Active)

func _on_weapons_manager_connect_weapon_to_hud(_weapon_resouce):
	_weapon_resouce.connect("UpdateOverlay", Callable(self, "LoadOverLayTexture"))

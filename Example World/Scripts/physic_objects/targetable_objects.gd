extends RigidBody3D

@onready var health_counter = $HealthCounter
@onready var hit_counter = $HitCounter

var Health = 99
var times_hit: int = 0

func _ready():
	update_health_label(Health)

func Hit_Successful(damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	var Hit_Position = _Position - get_global_transform().origin 
	Health -= damage
	times_hit += 1
	update_health_label(Health)
	if Health <= 0:
		queue_free()
		
	if _Direction != Vector3.ZERO:
		apply_impulse((_Direction*damage),Hit_Position)
		
func update_health_label(_health: float):
	health_counter.set_text("Health:" + str(_health))
	hit_counter.set_text("Times Hit:" + str(times_hit))

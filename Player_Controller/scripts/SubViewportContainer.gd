extends SubViewportContainer

@onready var ViewModelCamera = %ViewModelCamera

signal UpdateFOV

func _ready():
	emit_signal("UpdateFOV",ViewModelCamera.get_fov(), true)

func _on_fov_value_changed(value):
	ViewModelCamera.set_fov(value)
	emit_signal("UpdateFOV",ViewModelCamera.get_fov())

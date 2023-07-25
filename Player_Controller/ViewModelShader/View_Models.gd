@tool
#Credit to 2nafish117
#https://github.com/2nafish117/godot-viewmodel-render-test
#https://www.youtube.com/@2nafish117
#They solved this issue, I just converted to G4 and Made the tool script suit this project.

extends Node3D

signal UpdateFOV

@export var Mesh_With_Shader: Array[MeshInstance3D]

@export var viewmodelfov: float = 50.0 :set = set_viewmodelfov

func _ready():
	UpdateFOV.emit(viewmodelfov, true)

func set_viewmodelfov(val: float):
	viewmodelfov = val
	SetMeshFOV(viewmodelfov)
		
func SetMeshFOV(val):
	for n in Mesh_With_Shader:
		if n != null:
			for i in range(n.mesh.get_surface_count()):
				var mat: Material = n.get_active_material(i)
				if mat is ShaderMaterial:
					mat.set_shader_parameter("viewmodel_fov", val)

func _on_fov_value_changed(value):
	viewmodelfov = value
	UpdateFOV.emit(viewmodelfov)


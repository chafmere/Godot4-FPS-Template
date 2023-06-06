@tool
extends Node3D

@export var Mesh_Wish_Shader: Array[NodePath]

@export var viewmodelfov: float = 50.0 :set = set_viewmodelfov

func set_viewmodelfov(val: float) -> void:
	if Engine.is_editor_hint():
		viewmodelfov = val
		SetMeshFOV(viewmodelfov)
	else:
		viewmodelfov = val

func SetMeshFOV(val):
	var Meshes = GetMeshes()
	for n in Meshes:
		for i in range(n.mesh.get_surface_count()):
			var mat: Material = n.get_active_material(i)
			if mat is ShaderMaterial:
				print(val)
				mat.set_shader_parameter("viewmodel_fov", val)
	
func GetMeshes()->Array:
	var MeshArray = []

	for NP in Mesh_Wish_Shader:
		var n = get_node(NP)
		MeshArray.push_front(n)

	return MeshArray

func _on_fov_value_changed(value):
	viewmodelfov = value
	SetMeshFOV(viewmodelfov)

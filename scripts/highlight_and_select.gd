# Highlightable.gd
extends RigidBody3D

@export var highlight_color: Color = Color(1, 1, 0) # Yellow
var original_colors: Array = []

func _ready():
	var new_mat = StandardMaterial3D.new()
	if self.is_in_group("good_object"):
		new_mat.albedo_color = Color(0.0, 0.4, 0.0)
	else:
		new_mat.albedo_color = Color(0.4, 0.0, 0.0)
	# Store all MeshInstance3D original modulate colors
	#var counter = 0;
	for child in get_children():
		#print(child.name)
		for mesh in child.get_children():
			#print(mesh.name)
			if mesh is MeshInstance3D:
				#new_mat.albedo_color = Color(1,1,1) #white
				#var mat = mesh.material_override
				mesh.material_override = new_mat
				original_colors.append([mesh, new_mat.albedo_color])
				
				#print(mesh.mesh != null)
				#var surface = mesh.mesh.surface_get_material(0)
				#original_colors.append([mesh, surface.albedo_color])
				#var original_material = mesh.material_override
				#original_colors.append([mesh, original_material.albedo_color])
				
func highlight():
	for pair in original_colors:
		var mesh = pair[0]
		mesh.material_override.albedo_color = highlight_color
		
		
func unhighlight():
	for pair in original_colors:
		var mesh = pair[0]
		var original_mat = pair[1]
		mesh.material_override.albedo_color = original_mat
		# Check if the material is a StandardMaterial3D
		#if mesh.material_override is StandardMaterial3D:
			# Restore the original color
		#	(mesh.material_override as StandardMaterial3D).albedo_color = original_mat

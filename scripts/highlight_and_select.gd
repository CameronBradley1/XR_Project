# highlight_and_select.gd
extends RigidBody3D

signal object_selected(object)
signal object_deselected(object)

@export var highlight_color: Color = Color(1, 1, 0) # Yellow
@export var selection_color: Color = Color(0, 1, 1) # Cyan
var original_colors: Array = []
var selection_meshes: Array = []
var is_selected: bool = false

func _ready():
	var new_mat = StandardMaterial3D.new()
	if self.is_in_group("good_object"):
		new_mat.albedo_color = Color(0.0, 0.4, 0.0)
	else:
		new_mat.albedo_color = Color(0.4, 0.0, 0.0)
	# Store all MeshInstance3D original modulate colors
	for child in get_children():
		for mesh in child.get_children():
			if mesh is MeshInstance3D:
				mesh.material_override = new_mat
				original_colors.append([mesh, new_mat.albedo_color])
				
func highlight():
	for pair in original_colors:
		var mesh = pair[0]
		mesh.material_override.albedo_color = highlight_color
		
func unhighlight():
	if not is_selected:
		for pair in original_colors:
			var mesh = pair[0]
			var original_mat = pair[1]
			mesh.material_override.albedo_color = original_mat
	else:
		# Keep selection color if selected
		for pair in original_colors:
			var mesh = pair[0]
			mesh.material_override.albedo_color = selection_color

func toggle_selection():
	if is_selected:
		deselect()
	else:
		select()

func select():
	is_selected = true
	
	# Remove any existing selection meshes (just in case)
	clear_selection_meshes()
	
	# Create selection meshes for each original mesh
	for pair in original_colors:
		var original_mesh = pair[0]
		
		# Create a new mesh instance for selection indicator
		var selection_mesh = MeshInstance3D.new()
		# Clone the mesh from the original
		selection_mesh.mesh = original_mesh.mesh.duplicate()
		
		# Create and apply material
		var selection_material = StandardMaterial3D.new()
		selection_material.albedo_color = selection_color
		selection_material.flags_transparent = true
		selection_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		selection_material.albedo_color.a = 0.5 # Semi-transparent
		selection_mesh.material_override = selection_material
		
		# Make it slightly bigger (1.05x scale)
		selection_mesh.scale = Vector3(1.05, 1.05, 1.05)
		
		# Add to the scene and store reference
		add_child(selection_mesh)
		selection_meshes.append(selection_mesh)
		
		# Also change the original color to selection color
		original_mesh.material_override.albedo_color = selection_color
	
	# Emit signal that this object was selected
	emit_signal("object_selected", self)

func deselect():
	is_selected = false
	
	# Clear selection meshes
	clear_selection_meshes()
	
	# Restore original colors
	for pair in original_colors:
		var mesh = pair[0]
		var original_mat = pair[1]
		mesh.material_override.albedo_color = original_mat
	
	# Emit signal that this object was deselected
	emit_signal("object_deselected", self)

func clear_selection_meshes():
	for mesh in selection_meshes:
		if is_instance_valid(mesh):
			mesh.queue_free()
	selection_meshes.clear()

extends Node3D

@onready var area = $Area3D
var objects_inside: Array[Node3D] = []

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is Node3D:
		if body.is_in_group("object"):
			objects_inside.append(body)
			#print(objects_inside.size())

func _on_body_exited(body):
	if body.is_in_group("object"):
		objects_inside.erase(body)
		#print(objects_inside.size())


func get_average_distance() -> Dictionary:
	var main = get_node("/root/main")
	if objects_inside.size() == 0:
		#print(objects_inside.size())jo
		return {"distance": -1.0, "avg_pos": global_transform.origin}

	var sum_pos = Vector3.ZERO
	for obj in objects_inside:
		for child in obj.get_children():
			if child is CollisionShape3D:
				sum_pos += child.global_transform.origin
	

	var avg_pos = sum_pos / objects_inside.size()
	var parent_pos = global_transform.origin
	var distance = parent_pos.distance_to(avg_pos)
	
	return {"distance": distance, "avg_pos": avg_pos}


func create_view(dist: float, avg_pos: Vector3, transform)-> void:
	var new_origin := XROrigin3D.new()
	var new_camera := Camera3D.new()
	new_camera.fov = 180.0
	
	new_origin.name = "EyesOrigin"
	#add_child(new_origin)
	#new_origin.add_child(new_camera)
	var dir_to_target = (transform.origin - avg_pos).normalized()

	var new_pos = transform.origin.lerp(avg_pos, .9)
	

	var viewport := SubViewport.new()
	viewport.name = "EyesViewport"
	viewport.size = Vector2i(512, 512)
	#viewport.usage = SubViewport.USAGE_3D
	viewport.disable_3d = false
	viewport.world_3d = get_world_3d()
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	#viewport.render_target_v_flip = true  # flip for correct orientation
	#viewport.add_child(new_origin)
	new_camera.current = true
	
	
	var screen := MeshInstance3D.new()
	#screen.mesh = create_circle(10.0, 32)
	screen.mesh = QuadMesh.new()
	screen.mesh.size = Vector2(1.0, 1.0)
	var object := StaticBody3D.new()
	var shape := CollisionShape3D.new()
	shape.shape = BoxShape3D.new()
	shape.shape.size = Vector3(1.0, 1.0, 1.0)
	object.add_child(shape)
	screen.add_child(object)
	#var new_pos = transform.origin.lerp(avg_pos, .9)
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = viewport.get_texture()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	screen.material_override = mat
	add_child(screen)
	screen.add_child(viewport)
	viewport.add_child(new_camera)
	#var original = Node3D.new()
	#screen.add_child(original)
	#original.globale_transform = new_camera.global_transform
	new_camera.global_transform.origin = new_pos
	var temp = MeshInstance3D.new()
	temp.mesh = SphereMesh.new()
	temp.scale = Vector3(.01,.01,.01)
	temp.material_override = StandardMaterial3D.new()
	screen.add_child(temp)
	var offset = dir_to_target * 0.03
	screen.global_transform.origin = transform.origin + offset
	screen.global_transform.basis = transform.basis
	#screen.mesh.global_transform.origin = transform.origin
	#print("picture position: ", screen.mesh.transform.origin)
	screen.look_at(global_transform.origin, Vector3.UP)
	object.add_to_group("screen")
	print("Viewport texture valid:", viewport.get_texture() != null)
	print("position of circle: ", screen.global_transform.origin)
	print("Camera current:", new_camera.current)
	

	
	

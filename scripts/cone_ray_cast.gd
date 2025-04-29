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


func get_average_distance() -> float:
	if objects_inside.size() == 0:
		#print(objects_inside.size())
		return -1.0

	var sum_pos = Vector3.ZERO
	for obj in objects_inside:
		sum_pos += obj.global_transform.origin

	var avg_pos = sum_pos / objects_inside.size()
	var parent_pos = global_transform.origin
	var distance = parent_pos.distance_to(avg_pos)
	return parent_pos.distance_to(avg_pos)
	
func create_view(dist):
	var world := World3D.new()
	var vp := SubViewport.new()
	vp.name = "preview"
	vp.size = Vector2i(512,512)
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	vp.world_3d = world
	#vp.disable_3d = false  # Enable 3D rendering
	#vp.world_3d = get_viewport().world_3d
	#vp.disable_input = true
	#vp.transparent_bg = true
	add_child(vp)
	
	var cam := Camera3D.new()
	cam.current = true
	vp.add_child(cam)
	
	#var dist := 10.0
	var fwd := -global_transform.basis.z.normalized()
	cam.global_transform.origin = global_transform.origin + fwd * dist
	cam.look_at(global_transform.origin, Vector3.UP)

	var tex_rect := TextureRect.new()
	tex_rect.texture = vp.get_texture()
	tex_rect.custom_minimum_size = Vector2(256, 256)
	get_tree().root.add_child(tex_rect)  # Shows it in the main UI

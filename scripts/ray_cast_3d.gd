extends RayCast3D
#@export var controller: XRController
# The trigger action from OpenXR
var ray_script = load("res://scripts/ray_cast_3d.gd")
const TRIGGER_ACTION = "trigger_action"
var last_hovered: Node = null
var ray_length = 1000
var is_copy = false
#var second_raycast: RayCast3D
# Called when the node enters the scene tree for the first time.


func set_copy():
	is_copy = true
	


func _ready() -> void:
	
	pass # Replace with function body.

func check() -> void:
	if is_colliding():
		var hit = get_collider()
		if hit.is_in_group("good_object"):
			print("correct")
		else:
			print("incorrect")
		if hit.is_in_group("object"):
			print("object")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_copy == false:
		var hovered = null
		if is_colliding():
			#highlight object
			var hit = get_collider()
			if hit.is_in_group("object"):
				#print(hit.name)
				hovered = hit
			if hit.is_in_group("screen"):
				#hovered = hit
				var hit_position = get_collision_point()
				var screen = hit.get_parent()
				var lens_node = screen.get_parent()
				var original_position = screen.global_transform
				#var original_orient = screen.global_orientation
				#var forward = l.global_transform.basis.z.normalized()
				for node in screen.get_children():
					if node is SubViewport:
						for cam in node.get_children():
							if cam is Camera3D:
								var raycast = self.duplicate()
								raycast.set_copy()
								cam.add_child(raycast)
								
								cam.rotation = self.get_parent().global_rotation

								
								raycast.force_raycast_update()
								
								var hit2 = raycast.get_collider()
								if hit2 != null and hit2.is_in_group("object"):
									hovered = hit2
									
								#raycast.global_transform.origin = cam.global_transform.origin + scaled_offset
								#var cam_face = cam.global_transform.basis.z.normalized()
								#raycast.global_transform.origin += cam_face * 2 
								#raycast.global_rotation = self.global_rotation
								#raycast.rotation = cam.
								#raycast.global_transform.origin = cam.global_transform.origin + scaled_offset
								#raycast.global_transform.origin += cam_face * 2
								#raycast.global_rotation = self.global_rotation
								#raycast.force_raycast_update()
								#var hit2 = raycast.check_collide()
								#hit = raycast.check_collider()
								#if hit.is_in_group("object"):
								#	hovered = hit
								#cam.remove_child(raycast)
							
								
								
				
				
				#print("hit screen")
		
		if hovered != last_hovered:
			if last_hovered and last_hovered.has_method("unhighlight"):
				last_hovered.unhighlight()
			if hovered and hovered.has_method("highlight"):
				#print(hovered.name)
				hovered.highlight()
			last_hovered = hovered
		
		
	
	

extends RayCast3D
#@export var controller: XRController
# The trigger action from OpenXR
const TRIGGER_ACTION = "trigger_action"
var last_hovered: Node = null
# Called when the node enters the scene tree for the first time.
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
	var hovered = null
	if is_colliding():
		#highlight object
		var hit = get_collider()
		if hit.is_in_group("object"):
			#print(hit.name)
			hovered = hit
	
	if hovered != last_hovered:
		if last_hovered and last_hovered.has_method("unhighlight"):
			last_hovered.unhighlight()
		if hovered and hovered.has_method("highlight"):
			#print(hovered.name)
			hovered.highlight()
		last_hovered = hovered
	
	

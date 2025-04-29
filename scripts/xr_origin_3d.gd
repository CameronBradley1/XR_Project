extends Node

# Called when the node enters the scene tree for the first time.
var xr_interface: XRInterface
@export var right_node : XRController3D  # The right controller node you want to switch to
@export var scope_node : XRController3D  # The new controller node to switch to
var parent_node = null

func _ready():
	parent_node = get_node("/root/main")
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
		
	else:
		print("OpenXR not initialized, please check if your headset is connected")
	
	right_node = $right_controller
	scope_node = $scope
	right_node.visible = true
	scope_node.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func switch_controller() -> void:
	right_node.visible = !right_node.visible
	scope_node.visible = !scope_node.visible
	
func create_duplicate(original: Node3D) -> Node3D:
	var copy = original.duplicate()
	copy.transform = original.global_transform
	original.get_parent().get_parent().get_parent().add_child(copy)
	return copy
	
func remove_last(copy: Node3D) -> void:
	parent_node.remove_child(copy)
	

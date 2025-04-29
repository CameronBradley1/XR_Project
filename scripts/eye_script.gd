extends XRController3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#I want to use a function like this to spawn and move the camera
func spawn_and_look(original: Node3D, target_position: Array[Vector3]) -> void:
	var clone := original.duplicate()

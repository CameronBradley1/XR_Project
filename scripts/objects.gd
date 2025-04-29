extends Node3D
var object_script = load("res://scripts/highlight_and_select.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		for object in child.get_children():
			if object is RigidBody3D:
				#print(object.name)
				object.add_to_group("object")
				object.set_script(object_script)
				object._ready()
				

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

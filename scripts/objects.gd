extends Node3D
var object_script = load("res://scripts/highlight_and_select.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		for object in child.get_children():
			if object is RigidBody3D:
				# Add all RigidBody3D objects to the "object" group
				object.add_to_group("object")
				
				# Check if this object should be a "good" object
				# All objects with names starting with "Object_select" are considered good
				if object.name.begins_with("Object_select"):
					object.add_to_group("good_object")
					print("Added " + object.name + " to good_object group")
				
				# Attach the script
				object.set_script(object_script)
				object._ready()

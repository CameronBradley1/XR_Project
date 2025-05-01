extends Node3D

# Timer variables
var timer_active = false
var start_time = 0
var elapsed_time = 0
var final_time = 0

# Text display
var text_instance: Label3D

# Tracking selected objects
var good_objects = []
var selected_good_objects = 0
var total_good_objects = 0

func _ready():
	# Create 3D text for the timer
	text_instance = Label3D.new()
	text_instance.text = "00:00.000"
	text_instance.font_size = 64
	text_instance.modulate = Color(1, 1, 1)
	text_instance.outline_size = 4
	text_instance.outline_modulate = Color(0, 0, 0)
	text_instance.no_depth_test = true # Ensure always visible
	add_child(text_instance)
	
	# Position the timer text in front of the camera
	text_instance.transform.origin = Vector3(0, 0.15, -0.5)
	
	# Wait a frame to ensure all objects have their scripts attached and groups assigned
	call_deferred("find_good_objects")

func find_good_objects():
	# Find all good objects in the scene
	var objects_node = get_node("/root/main/Objects")  # Adjust path as needed
	
	if objects_node:
		# Look through all holders and their children
		for holder in objects_node.get_children():
			for object in holder.get_children():
				if object.is_in_group("good_object"):
					good_objects.append(object)
					# Connect signals if the object has them
					object.connect("object_selected", Callable(self, "_on_object_selected"))
					object.connect("object_deselected", Callable(self, "_on_object_deselected"))
					total_good_objects += 1
	
	print("Found ", total_good_objects, " good objects to select")

func _process(delta):
	if timer_active:
		elapsed_time = Time.get_ticks_msec() - start_time
		update_timer_display()

func start_timer():
	if not timer_active:
		timer_active = true
		start_time = Time.get_ticks_msec()
		print("Timer started")

func stop_timer():
	if timer_active:
		timer_active = false
		final_time = elapsed_time
		print("Timer stopped. Final time: ", format_time(final_time))

func reset_timer():
	timer_active = false
	elapsed_time = 0
	final_time = 0
	selected_good_objects = 0
	update_timer_display()
	print("Timer reset")

func update_timer_display():
	text_instance.text = format_time(elapsed_time)

func format_time(time_ms):
	var minutes = time_ms / 60000
	var seconds = (time_ms % 60000) / 1000
	var milliseconds = time_ms % 1000
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]

func _on_object_selected(object):
	if object.is_in_group("good_object"):
		selected_good_objects += 1
		print("Good object selected: ", selected_good_objects, "/", total_good_objects)
		
		# Start timer on first selection
		if selected_good_objects == 1:
			start_timer()
		
		# Stop timer when all good objects are selected
		if selected_good_objects == total_good_objects:
			stop_timer()

func _on_object_deselected(object):
	if object.is_in_group("good_object"):
		selected_good_objects -= 1
		print("Good object deselected: ", selected_good_objects, "/", total_good_objects)
		
		# Restart timer if it was stopped and we deselect an object
		if not timer_active and selected_good_objects > 0:
			start_timer()

extends XRController3D

var trigger_clicked = false
var switch_clicked = false
var switch_clicked2 = false
var queue: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var scope = get_node("/root/main/player/scope/lens_node")
	var player = get_node("/root/main/player")
	var ray = get_node("/root/main/player/right_controller/RayCast3D")
	var trigger = get_input("trigger_click")
	var switch = get_input("ax_button")
	var switch2 = get_input("by_button")
	if trigger == true:
		if trigger_clicked == false:
			ray.check()
			trigger_clicked = true
	else:
		trigger_clicked = false
	
	if switch == true:
		if switch_clicked == false:
			player.switch_controller()
			switch_clicked = true
	else:
		if switch_clicked == true:
			var forward = self.global_transform.basis.z.normalized()
			var result = scope.get_average_distance()
			var dupli = player.create_duplicate(scope, forward) 
			#print(dupli.global_transform.origin)
			dupli.create_view(result.distance, result.avg_pos, dupli.global_transform)
			#dupli.create_view(average_dis - (average_dis / 10))
			queue.append(dupli)
			
			
			#print(average)
			player.switch_controller()
			#Need to set microscope
		switch_clicked = false
		
	if switch2 == true:
		if switch_clicked2 == false:
			if not queue.is_empty():
				player.remove_last(queue.pop_back())
			switch_clicked2 = true
	else:
		switch_clicked2 = false

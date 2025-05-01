extends XRController3D

var timer_display
var primary_button_pressed = false

func _ready():
	# Find the timer display node
	timer_display = get_node("/root/main/TimerDisplay")
	if not timer_display:
		print("Timer display not found!")

func _process(delta):
	# Check for primary button press (X/A button)
	var primary_button = get_input("ax_button")
	
	if primary_button:
		if not primary_button_pressed:
			# Button just pressed
			primary_button_pressed = true
			
			# Reset the timer
			if timer_display:
				timer_display.reset_timer()
				print("Timer reset by left controller")
	else:
		primary_button_pressed = false

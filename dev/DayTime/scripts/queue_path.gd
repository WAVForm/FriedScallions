extends Path3D

const customer_display_scene = preload("res://dev/DayTime/scenes/customer_display.tscn")

var customer_displays: Array[PathFollow3D] = []

func update_customers(customers: Array[Customer]) -> void:
	var difference = len(customers) - len(customer_displays)
	if difference > 0:
		for i in range(difference):
			var new_customer_display = customer_display_scene.instantiate()
			customer_displays.append(new_customer_display)
			add_child(new_customer_display)
	elif difference < 0:
		for i in range(-difference):
			var removed_customer_display = customer_displays.pop_back()
			removed_customer_display.queue_free()
	for i in range(len(customers)):
		customer_displays[i].progress_ratio = (200.0 - customers[i].position) / 200.0
		var percentage = customers[i].patience_percentage
		var customer_color
		if percentage > 0.5:
			customer_color = Color(2.0 * (1.0 - percentage), 1.0, 0.0)
		else:
			customer_color = Color(1.0, 2.0 * (percentage), 0.0)
		customer_displays[i].set_color(customer_color)

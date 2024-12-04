extends Node3D

const product_display_scene = preload("res://dev/DayTime/scenes/product_display.tscn")

var product_displays: Array[Sprite3D] = []

func update_counter(products: Array[Product]) -> void:
	var difference = len(products) - len(product_displays)
	if difference > 0:
		for i in range(difference):
			var new_product_display = product_display_scene.instantiate()
			product_displays.append(new_product_display)
			add_child(new_product_display)
	elif difference < 0:
		for i in range(-difference):
			var removed_product_display = product_displays.pop_back()
			removed_product_display.queue_free()
	for i in range(len(products)):
		product_displays[i].position.x = i * 0.75
		product_displays[i].texture = products[i].texture

func serve_items(products: Array[Product]) -> void:
	for i in len(products):
		var new_product_display = product_display_scene.instantiate()
		new_product_display.texture = products[i].texture
		add_child(new_product_display)
		new_product_display.serve(0.25 * i)

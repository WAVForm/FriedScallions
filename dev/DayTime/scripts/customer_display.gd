extends PathFollow3D

@onready var model = $Model

func set_color(color: Color):
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = color
	model.set_surface_override_material(0, material)
	

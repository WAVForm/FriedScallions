extends PathFollow3D

@onready var model = $Model

func set_color(color: Color):
	var material: StandardMaterial3D = model.get_surface_override_material(0)
	material.albedo_color = color
	

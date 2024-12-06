extends PathFollow3D

@onready var model = $Model

signal customer_clicked

func _ready():
	$Area3D.input_event.connect(func(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int): 
		if event.is_pressed() and event is InputEventMouseButton and event.button_index == 1:
			if self == get_parent().customer_displays.front():
				get_parent().customer_clicked.emit()
	)

func set_color(color: Color):
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = color
	model.set_surface_override_material(0, material)
	

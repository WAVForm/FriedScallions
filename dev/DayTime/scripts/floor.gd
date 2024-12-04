extends Area3D

@onready var player = $player
var start = null
var target = null
var time = 0.0

func _ready():
	self.input_ray_pickable = true
	self.input_event.connect(func(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int): 
		if event.is_pressed() and event is InputEventMouseButton and event.button_index == 1:
			time = 0.0
			target = Vector3(event_position.x, player.position.y, event_position.z)
	)

func _physics_process(delta):
	if target != null:
		player.position = player.position.lerp(target, time)
		time += delta
		if time >= 1.0:
			target = null
			time = 0.0

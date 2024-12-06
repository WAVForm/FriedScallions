extends Area3D

class_name Person

@onready var check_front = $check_front
@onready var textbox = $text
@onready var model = $model
var id: int

var day_parent:Node3D
var side:Node3D
var current_path:Path3D
enum STATES {NONE, TO_ADVERT, AT_ADVERT, CROSSING, TO_LINE, IN_LINE, AT_DOOR, TO_REGISTER, AT_REGISTER, FROM_REGISTER, LEAVING, LEFT}
var state:STATES = STATES.NONE

var started = false
var moving = false
var path_len = 0.0
var progress = 0.0
var max_progression = 0.25
var wait_time = 1.0

var order: Array
var patience: float = 30.0
var max_patience: float = 30.0
var ordered = false
var order_done = false

var patience_percentage: float:
	get: 
		return patience / max_patience

func init(order_products: Array, initial_patience: float) -> void:
	order = order_products
	patience = initial_patience
	max_patience = initial_patience

func gt(other:Person):	
	if not other is Person:
		return true
	elif state > other.state:
		return true
	elif state < other.state:
		return false
	elif state == other.state and progress > other.progress:
		return true
	elif state == other.state and progress <= other.progress:
		return false
	elif id < other.id:
		return true
	elif id >= other.id:
		return false
	else:
		return false

func _ready():
	check_front.exclude_parent = true
	check_front.collide_with_areas = true
	
	self.input_event.connect(func(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int):
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
			get_parent().get_parent().customer_clicked.emit(self)
		)

func start(p_id: int):
	id = p_id
	side = self.get_parent() as Node3D
	day_parent = side.get_parent() as Node3D
	state = STATES.TO_ADVERT
	textbox.visible = false
	#populate_textbox()
	day_parent.set_current_path(self)
	self.position = current_path.curve.get_point_position(0) + current_path.position
	started = true
	moving = true

func try_move(delta):
	var no_ray = true
	var no_inside = true
	var other = check_front.get_collider()
	if other is Person and other.gt(self):
		no_ray = false
	if self.has_overlapping_areas():
		for each in self.get_overlapping_areas():
			if each is Person and each.gt(self):
				no_inside = false
				break
				
	if no_ray and no_inside or (not no_ray and state == STATES.CROSSING):
		moving = true
	else:
		moving = false
		
	if moving:
		move_on_path(delta)

func move_on_path(delta):
	if current_path != null:
		if progress + (path_len * max_progression * delta) < path_len:
			progress += path_len * max_progression * delta
			self.transform = current_path.curve.sample_baked_with_rotation(progress)
			self.position += current_path.position
		else:
			self.transform = current_path.curve.sample_baked_with_rotation(path_len)
			self.position += current_path.position
			progress = 0
			if state == STATES.CROSSING:
				day_parent.switch_side(self)
			state += 1
			day_parent.set_current_path(self)
	else:
		if state == STATES.AT_ADVERT:
			if progress < wait_time:
				progress += delta
			else:
				var to_friendly = Roll.roll(WRAPPER.popularity)
				if to_friendly and side.name == "enemy":
					state = STATES.CROSSING
				else:
					state = STATES.TO_LINE
				progress = 0
				day_parent.set_current_path(self)
		elif state == STATES.AT_DOOR:
			if progress < wait_time:
				progress += delta
			else:
				progress = 0
				state += 1
				day_parent.set_current_path(self)
		elif state == STATES.AT_REGISTER:
			populate_textbox()
			if not ordered:
				textbox.visible = true
				ordered = true
			if order_done:
			#this is where daytime stuff happens
			#then do move on with below code
				textbox.visible = false
				progress = 0
				state += 1
				day_parent.set_current_path(self)
			elif side.name == "enemy":
				if progress < wait_time:
					progress += delta
				else:
					textbox.visible = false
					progress = 0
					state += 1
					day_parent.set_current_path(self)
		elif state == STATES.LEFT:
			get_parent().get_parent().customer_despawned.emit(self)
			queue_free()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started:
		try_move(delta)
	
	#set patience color
	var customer_color
	if patience_percentage > 0.5:
		customer_color = Color(2.0 * (1.0 - patience_percentage), 1.0, 0.0)
	else:
		customer_color = Color(1.0, 2.0 * (patience_percentage), 0.0)
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = customer_color
	model.set_surface_override_material(0, material)
		
func populate_textbox():
	textbox.text = ""
	for item in order:
		textbox.text += item.name + "\n"
		

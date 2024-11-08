extends Area3D

class_name Person

@onready var check_front = $check_front
@onready var textbox = $text
@onready var background = $textbox_bg
var items:Array
var id: int

var outside:Node3D
var parent:Node3D
var current_path:Path3D
var advert_path:Path3D
var cross_path:Path3D
var line_path:Path3D
var line:Path3D
enum STATES {NONE, TO_ADVERT, AT_ADVERT, CROSSING, TO_LINE, IN_LINE, AT_DOOR, TO_REGISTER, FROM_REGISTER}
var state:STATES = STATES.NONE

var started = false
var moving = false
var progress = 0.0
var max_progression = 0.25

func gt(other:Person):
	if not other is Person:
		return true
	elif id < other.id:
		return true
	elif id >= other.id:
		return false
	elif state > other.state:
		return true
	elif state < other.state:
		return false
	elif state == other.state and progress > other.progress:
		return true
	elif state == other.state and progress <= other.progress:
		return false
	else:
		return false

func _ready():
	check_front.exclude_parent = true
	check_front.collide_with_areas = true

func start(p_id: int):
	id = p_id
	parent = self.get_parent() as Node3D
	outside = parent.get_parent() as Node3D
	advert_path = parent.get_node("path_to_advert") as Path3D
	cross_path = parent.get_node("crossing_path") as Path3D
	line_path = parent.get_node("path_to_line") as Path3D
	line = parent.get_node("line") as Path3D
	state = STATES.TO_ADVERT
	textbox.visible = false
	background.visible = false
	populate_textbox()
	self.position = advert_path.curve.get_point_position(0) + advert_path.position
	started = true
	moving = true
	
func reset():
	parent = self.get_parent() as Node3D
	outside = parent.get_parent() as Node3D
	advert_path = parent.get_node("path_to_advert") as Path3D
	cross_path = parent.get_node("crossing_path") as Path3D
	line_path = parent.get_node("path_to_line") as Path3D
	line = parent.get_node("line") as Path3D

func try_move(delta):
	var no_ray = true
	var no_inside = true
	if check_front.get_collider() is Person and check_front.get_collider().gt(self):
		no_ray = false
	if self.has_overlapping_areas():
		for each in self.get_overlapping_areas():
			if each is Person and each.gt(self):
				no_inside = false
				break
				
	var flag_idx = 0 if parent.name == "friendly" else 1
	if no_ray and no_inside or (not no_ray and state == STATES.CROSSING):
		moving = true
	else:
		moving = false
		
	if moving:
		move_on_path(delta)

func move_on_path(delta):
	if state == STATES.TO_REGISTER or state == STATES.FROM_REGISTER:
		1 + 1
	else:
		current_path = advert_path if state == STATES.TO_ADVERT else cross_path if state == STATES.CROSSING else line_path if state == STATES.TO_LINE else line if state == STATES.IN_LINE else null
	if current_path != null:
		var len = current_path.curve.get_baked_length()
		if progress + (len * max_progression * delta) < len:
			progress += len * max_progression * delta
			self.transform = current_path.curve.sample_baked_with_rotation(progress)
			self.position += current_path.position
		else:
			self.transform = current_path.curve.sample_baked_with_rotation(len)
			self.position += current_path.position
			progress = 0
			if state == STATES.CROSSING:
				var old_p_name = parent.name
				parent.remove_child(self)
				outside.get_node("friendly" if old_p_name == "enemy" else "enemy").add_child(self)
				reset()
			state += 1
	else:
		if state == STATES.AT_ADVERT:
			if progress < 1.0:
				progress += delta
			else:
				var to_friendly = Roll.roll(WRAPPER.popularity)
				if to_friendly and parent.name == "enemy" or not to_friendly and parent.name == "friendly":
					state = STATES.CROSSING
				else:
					state = STATES.TO_LINE
				progress = 0
		else:
			outside.can_enter.connect(on_enter)
			moving = false
			started = false

func on_enter():
	if parent.name == "friendly":
		WRAPPER.friendly_shop_entered.emit()
	elif parent.name == "enemy":
		WRAPPER.enemy_shop_entered.emit()
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started:
		try_move(delta)
		
func populate_textbox():
	for item in items:
		textbox.text += item.name + "\n"
		
func text_appear():
	textbox.visible = true
	background.visible = true
	

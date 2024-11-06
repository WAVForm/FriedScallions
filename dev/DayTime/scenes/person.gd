extends Area3D

class_name Person

@onready var check_front = $check_front
@onready var top_info = $info
var id: int

var parent:Node3D
var advert_path:Path3D
var line_path:Path3D
var line:Path3D
enum STATES {NONE, TO_ADVERT, AT_ADVERT, TO_LINE, IN_LINE, AT_DOOR, INSIDE}
var state:STATES = STATES.NONE

var started = false
var moving = false
var progress = 0.0
var max_progression = 0.5

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
	advert_path = parent.get_node("path_to_advert") as Path3D
	line_path = parent.get_node("path_to_line") as Path3D
	line = parent.get_node("line") as Path3D
	state = STATES.TO_ADVERT
	self.position = advert_path.curve.get_point_position(0) + advert_path.position
	started = true
	moving = true

func try_move(delta):
	var no_ray = true
	var no_inside = true
	if check_front.get_collider() is Person:
		no_ray = false
	if self.has_overlapping_areas():
		for each in self.get_overlapping_areas():
			if each is Person and each.gt(self):
				no_inside = false
				break
	if no_ray and no_inside:
		moving = true
	else:
		moving = false
		
	if moving:
		move_on_path(delta)

func move_on_path(delta):
	var current_path = advert_path if state == STATES.TO_ADVERT else line_path if state == STATES.TO_LINE else line if state == STATES.IN_LINE else null
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
			state += 1
	else:
		if state == STATES.AT_ADVERT:
			if progress < 1.0:
				progress += delta
			else:
				progress = 0
				state += 1
		else:
			started = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started:
		try_move(delta)
		top_info.text = "P: " + str(progress) + " | ID: " + str(id)
		top_info.rotation.y = 0 - self.rotation.y

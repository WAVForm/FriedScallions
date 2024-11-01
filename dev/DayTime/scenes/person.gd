extends Area3D

class_name Person

var id: int

var parent:Node3D
var advert_path:Path3D
var line_path:Path3D
var line:Path3D
enum STATES {NONE, TO_ADVERT, AT_ADVERT, TO_LINE, IN_LINE, AT_DOOR, INSIDE}
var state:STATES = STATES.NONE

var started = false
var moving = false
var speed = 1
var progress = 0.0

func gt(other:Person):
	if not other is Person:
		return true
	elif state > other.state:
		return true
	elif state == other.state and progress > other.progress:
		return true
	elif id < other.id:
		return true
	else:
		return false

func start(p_id: int):
	id = p_id
	parent = self.get_parent() as Node3D
	advert_path = parent.get_node("path_to_advert") as Path3D
	line_path = parent.get_node("path_to_line") as Path3D
	line = parent.get_node("line") as Path3D
	speed = (advert_path.curve.get_baked_length() + line_path.curve.get_baked_length() + line.curve.get_baked_length()) / 50
	state = STATES.TO_ADVERT
	self.position = advert_path.curve.get_point_position(0) + advert_path.position
	started = true
	moving = true

func try_move(delta):
	if moving:
		#check if should stop moving
		if self.has_overlapping_areas():#check for collisions
			var cols = self.get_overlapping_areas()#get collisions
			for each in cols: #for each collision
				if not self.gt(each):
					if each is Person and each.state != STATES.IN_LINE or (each.state == STATES.IN_LINE and state == STATES.IN_LINE) or (each.state == STATES.IN_LINE and state == STATES.TO_LINE and not each.moving and each.progress <= 0.01):
						moving = false
						break
			move_on_path(delta) #no valid collisions, move
		else: #no collisions, move
			move_on_path(delta)
	else:
		#check if should start moving
		if self.has_overlapping_areas():#check for collisions
			var should_move = true #should move unless a reason is found
			var cols = self.get_overlapping_areas() #get collisions
			for each in cols:
				if not self.gt(each):
					should_move = false
			if should_move:
				moving = true
				move_on_path(delta)
		else: #no collisions, move
			moving = true
			move_on_path(delta)
			

func move_on_path(delta):
	var current_path = advert_path if state == STATES.TO_ADVERT else line_path if state == STATES.TO_LINE else line if state == STATES.IN_LINE else null
	if current_path != null:
		if progress < 1.0:
			progress += delta*speed
			self.position =  current_path.curve.sample(0, progress) + current_path.position
		else:
			self.position = current_path.curve.sample(0, 1.0) + current_path.position
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

extends Node3D

var parent:Node3D
var advert_path:Path3D
var shop_path:Path3D
var line:Path3D
enum STATES {NONE, TO_ADVERT, AT_ADVERT, TO_SHOP, IN_LINE}
var state:STATES = STATES.NONE

var move_speed = 10
var progress = 0.0
var wait_time: Array = [0.0,0.0]

func start():
	parent = self.get_parent() as Node3D
	advert_path = parent.get_node("path_to_advert") as Path3D
	shop_path = parent.get_node("path_to_shop") as Path3D
	line = parent.get_node("line") as Path3D
	state = STATES.TO_ADVERT
	self.position = advert_path.curve.get_point_position(0) + advert_path.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state != STATES.NONE:
		match state:
			STATES.TO_ADVERT:
				if progress < 1.0:
					progress += delta / move_speed
					self.position = advert_path.curve.sample(0, progress) + advert_path.position
				else:
					self.position = advert_path.curve.sample(0, 1.0) + advert_path.position
					progress = 0
					wait_time[0] = randf_range(0, 5)
					state = STATES.AT_ADVERT
			STATES.AT_ADVERT:
				if wait_time[0] < wait_time[1]:
					wait_time[1] += delta
				else:
					#TODO check if line?
					self.position = shop_path.curve.sample(0, 0.0) + shop_path.position
					state = STATES.TO_SHOP
			STATES.TO_SHOP:
				if progress < 1.0:
					progress += delta / move_speed
					self.position = shop_path.curve.sample(0, progress) + shop_path.position
				else:
					self.position = shop_path.curve.sample(0, 1.0) + shop_path.position
					progress = 0
					state = STATES.NONE
			STATES.IN_LINE:
				pass

extends ColorRect

var time_limit = 15 #how long until sun sets and go to sleep menu
var progress = 0.0 #overall progress of setting

#concept, have a visual sun that moves across the sky, maybe rather than a circle progress bar
@onready var sun = $sun
var sun_rad = 250 #temporary, radius later should be based on screen size
var sun_start = Vector2()

func _ready():
	sun_start = sun.position #save where the sun is now

func _process(delta):
	if progress < 1.0: #fill progress
		progress += (1.0/time_limit)*delta
		self.material.set_shader_parameter("progress", progress)
		sun_pos()
	else: #when full
		self.get_parent().get_node("button_container").get_node("sleep_confirm").confirmed.emit()

#concept
func sun_pos():
	#ideally, clamp y to be between 0 and viewport.y, and x to be between 0 and viewport.x even if sun won't move past the 12 o'clock or 3 o'clock (or something)
	var x = sin(PI/2*progress)*sun_rad
	var y = -cos(PI/2*progress)*sun_rad
	sun.position = Vector2(x,y) + sun_start

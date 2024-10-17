extends ColorRect

var time_limit = 15 #how long until sun sets and go to sleep menu
var progress = 0.0 #overall progress of setting

var light_color = Color("#ffaf40")
var dark_color = Color("#030d25")

#concept, have a visual sun that moves across the sky, maybe rather than a circle progress bar
@onready var sun = $sun
var sun_rad = 250 #TODO temporary, radius later should be based on screen size
var sun_start = Vector2()
var offset = 0

@onready var buttons = $"../button_container"

func _ready():
	sun_start = sun.position #save where the sun is now
	self.material.set_shader_parameter("progress", 0) #just in case
	match WRAPPER.state:
		WRAPPER.SCENES.DAWN:
			self.material.set_shader_parameter("start_color", dark_color)
			self.material.set_shader_parameter("end_color", light_color)
			offset = -(PI/2)
		WRAPPER.SCENES.DUSK:
			self.material.set_shader_parameter("start_color", light_color)
			self.material.set_shader_parameter("end_color", dark_color)
			offset = 0
			
func _process(delta):
	if progress < 1.0: #fill progress
		progress += (1.0/time_limit)*delta
		self.material.set_shader_parameter("progress", progress)
		sun_pos()
	else: #when full
		buttons.default_confirm.confirmed.emit()

#concept
func sun_pos():
	#ideally, clamp y to be between 0 and viewport.y, and x to be between 0 and viewport.x even if sun won't move past the 12 o'clock or 3 o'clock (or something)
	var x = sin(((PI/2)*progress)+offset)*sun_rad
	var y = -cos(((PI/2)*progress)+offset)*sun_rad
	sun.position = Vector2(x,y) + sun_start

extends Control

var time_limit = 2 #how long until sun sets and go to sleep menu
var progress = 0.0 #overall progress of setting

var light_color = Color("#ffaf40")
var dark_color = Color("#030d25")

#concept, have a visual sun that moves across the sky, maybe rather than a circle progress bar
@onready var bg:ColorRect = $bg
@onready var sun:ColorRect = $bg/sun
var sun_rad = 250 #TODO temporary, radius later should be based on screen size
var sun_start = Vector2()
var offset = 0

@onready var day = $day_text

func _ready():
	sun_start = sun.position #save where the sun is now
	bg.material.set_shader_parameter("progress", 0) #just in case
	match WRAPPER.state:
		WRAPPER.SCENES.DAWN:
			bg.material.set_shader_parameter("start_color", dark_color)
			bg.material.set_shader_parameter("end_color", light_color)
			offset = -(PI/2)
		WRAPPER.SCENES.DUSK:
			bg.material.set_shader_parameter("start_color", light_color)
			bg.material.set_shader_parameter("end_color", dark_color)
			offset = 0
	set_day()
			
func _process(delta):
	if progress < 1.0: #fill progress
		progress += (1.0/time_limit)*delta
		bg.material.set_shader_parameter("progress", progress)
		sun_pos()
	else: #when full
		if WRAPPER.state == WRAPPER.SCENES.DAWN:
			WRAPPER.change_scene(WRAPPER.SCENES.DAY)
		elif WRAPPER.state == WRAPPER.SCENES.DUSK:
			WRAPPER.get_text_event()

#concept
func sun_pos():
	#ideally, clamp y to be between 0 and viewport.y, and x to be between 0 and viewport.x even if sun won't move past the 12 o'clock or 3 o'clock (or something)
	var x = sin(((PI/2)*progress)+offset)*sun_rad
	var y = -cos(((PI/2)*progress)+offset)*sun_rad
	sun.position = Vector2(x,y) + sun_start

func set_day():
	day.text = "Day " + str(WRAPPER.day)

extends Control

@onready var day_text:TextEdit = $day_text
@onready var dawn:ConfirmButton = $day_selection/dawn
@onready var dusk:ConfirmButton = $day_selection/dusk
@onready var day_scene:ConfirmButton = $misc/day_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	dawn.confirmed.connect(func():
		if day_text.text == "":
			WRAPPER.day = 1
		else:
			WRAPPER.day = int(day_text.text)
		WRAPPER.change_scene(WRAPPER.SCENES.DAWN)
	)
	dusk.confirmed.connect(func(): 
		if day_text.text == "":
			WRAPPER.day = 1
		else:
			WRAPPER.day = int(day_text.text)
		WRAPPER.change_scene(WRAPPER.SCENES.DUSK)
	)
	day_scene.confirmed.connect(func(): WRAPPER.change_scene(WRAPPER.SCENES.DAY_PARENT))

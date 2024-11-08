extends Control

@onready var day_text:TextEdit = $day_text
@onready var dawn:ConfirmButton = $day_selection/dawn
@onready var dusk:ConfirmButton = $day_selection/dusk
@onready var outside:ConfirmButton = $misc/outside
@onready var inside:ConfirmButton = $misc/inside

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
	outside.confirmed.connect(func(): WRAPPER.change_scene(WRAPPER.SCENES.OUTSIDE))
	inside.confirmed.connect(func(): WRAPPER.change_scene(WRAPPER.SCENES.INSIDE))

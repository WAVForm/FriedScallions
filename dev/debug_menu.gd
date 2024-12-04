extends Control

@onready var day_text:TextEdit = $day_text
@onready var dawn:ConfirmButton = $day_selection/dawn

# Called when the node enters the scene tree for the first time.
func _ready():
	dawn.confirmed.connect(func():
		if day_text.text == "":
			WRAPPER.day = 1
		else:
			WRAPPER.day = int(day_text.text)
		WRAPPER.change_scene(WRAPPER.SCENES.DAWN)
	)

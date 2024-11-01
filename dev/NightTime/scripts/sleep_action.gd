extends Control

func _ready():
	await WRAPPER.wait(2)
	if WRAPPER.state == WRAPPER.SCENES.ACTION:
		WRAPPER.slept = false
		#TODO what happens if action happened?
	else:
		WRAPPER.slept = true
	WRAPPER.change_scene(WRAPPER.SCENES.DAWN)

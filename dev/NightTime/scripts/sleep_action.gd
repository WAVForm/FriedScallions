extends Control

func _ready():
	await WRAPPER.wait(2)
	if WRAPPER.state == WRAPPER.SCENES.ACTION:
		0+0
		#TODO what happens if action happened?
	else:
		0+0
		#TODO what happens if slept?
	WRAPPER.change_scene(WRAPPER.SCENES.DAWN)

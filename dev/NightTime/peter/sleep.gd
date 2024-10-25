extends Control

func _ready():
	await WRAPPER.wait(2)
	WRAPPER.change_scene(WRAPPER.SCENES.DAWN)

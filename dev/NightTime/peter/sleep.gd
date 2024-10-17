extends Control

@onready var dawn_button = $to_dawn

func _ready():
	dawn_button.confirmed.connect(func(): WRAPPER.change_scene(WRAPPER.SCENES.DAWN))

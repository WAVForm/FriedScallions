extends Control

@onready var dusk_button = $back_to_dusk

func _ready():
	dusk_button.confirmed.connect(func(): get_tree().change_scene_to_file("res://dev/NightTime/peter/Dusk.tscn"))

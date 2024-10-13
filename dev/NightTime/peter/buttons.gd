extends VBoxContainer

@onready var action_button = $action_confirm
@onready var sleep_button = $sleep_confirm

func _ready():
	action_button.confirmed.connect(func():get_tree().change_scene_to_file("res://dev/NightTime/peter/Night.tscn"))
	sleep_button.confirmed.connect(func():get_tree().change_scene_to_file("res://dev/NightTime/peter/Sleep.tscn"))

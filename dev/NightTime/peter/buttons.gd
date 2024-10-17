extends VBoxContainer

@onready var night_confirm = get_node_or_null("night_confirm")
@onready var sleep_confirm = get_node_or_null("sleep_confirm")
@onready var day_confirm = get_node_or_null("day_confirm")

var default_confirm = null

func _ready():
	if night_confirm != null:
		night_confirm.confirmed.connect(func():WRAPPER.change_scene(WRAPPER.SCENES.NIGHT))
	if sleep_confirm != null:
		sleep_confirm.confirmed.connect(func():WRAPPER.change_scene(WRAPPER.SCENES.SLEEP))
		default_confirm = sleep_confirm
	if day_confirm != null:
		day_confirm.confirmed.connect(func(): WRAPPER.change_scene(WRAPPER.SCENES.DAY))
		default_confirm = day_confirm

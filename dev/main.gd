extends Node2D


const DEBUG_SCENE = preload("res://dev/debug_stuff.tscn")

const DAY_MAIN_SCENE = preload("res://dev/DayTime/day_main.tscn")
const NIGHT_MAIN_SCENE = preload("res://dev/NightTime/peter/Dusk.tscn")

const SAVE_FILE_LOCATION = "user://savegame.save"

const DEBUG = 99
const MAIN_MENU = 0
const DAY = 1
const NIGHT = 2

var current_child: Node = null
var state: int = 0

# Day Time Data
var ingredients: Array
var purchaseables: Array
var money: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enter_debug()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter_debug() -> void:
	exit_scene()
	current_child = DEBUG_SCENE.instantiate()
	current_child.day_time.connect(enter_day)
	current_child.night_time.connect(enter_night)
	add_child(current_child)
	state = DEBUG

func enter_day() -> void:
	exit_scene()
	current_child = DAY_MAIN_SCENE.instantiate()
	current_child.day_exit.connect(enter_debug)
	add_child(current_child)
	state = DAY

func enter_night() -> void:
	exit_scene()
	current_child = NIGHT_MAIN_SCENE.instantiate()
	add_child(current_child)
	state = NIGHT

func exit_scene() -> void:
	# Get data from each scene here before loading the next
	match state:
		MAIN_MENU:
			pass
		DAY:
			pass
		NIGHT:
			pass
	if current_child != null:
		current_child.queue_free()

func get_save() -> Dictionary:
	var save_dict = {
		"version" : 0.0,
		"state" : state
	}
	for ingredient in ingredients:
		save_dict[ingredient.name] = ingredient.count
	for purchaseable in purchaseables:
		save_dict[purchaseable.name] = purchaseable.count
	return save_dict

func save_game() -> void:
	var save_file = FileAccess.open(SAVE_FILE_LOCATION, FileAccess.WRITE)
	var json_string = JSON.stringify(get_save())
	save_file.store_line(json_string)

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE_LOCATION):
		return # no save file found
	var save_game = FileAccess.open(SAVE_FILE_LOCATION, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		# Creates the helper class to interact with JSON
		var json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var node_data = json.get_data()
		for i in node_data.keys():
			print(i, "   ", node_data[i], "   ", typeof(node_data[i]))
			# blah blah turn back into variables based on read data
			# TODO add this part

extends Node

const DEBUG_SCENE = preload("res://dev/debug_stuff.tscn")

const DAY_MAIN_SCENE = preload("res://dev/DayTime/day_main.tscn")
const DAWN_SCENE = preload("res://dev/NightTime/peter/Dawn.tscn")
const DUSK_SCENE = preload("res://dev/NightTime/peter/Dusk.tscn")
const NIGHT_SCENE = preload("res://dev/NightTime/peter/Night.tscn")
const SLEEP_SCENE = preload("res://dev/NightTime/peter/Sleep.tscn")

const SAVE_FILE_LOCATION = "user://savegame.save"

enum SCENES {NULL, MAIN_MENU, DAWN, DAY, DUSK, NIGHT, SLEEP, DEBUG}
var state: SCENES = SCENES.NULL

var current_child: Node = null

# Day Time Data
var ingredients: Array
var purchaseables: Array
var money: int

#Night Time Data
	#TODO Store actions? Or, buffs/debuffs?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_scene(SCENES.DEBUG)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene(sceneid: SCENES) -> void:
	exit_scene()
	match sceneid:
		SCENES.DAWN:
			current_child = DAWN_SCENE.instantiate()
			state = SCENES.DAWN
		SCENES.DAY:
			current_child = DAY_MAIN_SCENE.instantiate()
			state = SCENES.DAY
		SCENES.DUSK:
			current_child = DUSK_SCENE.instantiate()
			state = SCENES.DUSK
		SCENES.NIGHT:
			current_child = NIGHT_SCENE.instantiate()
			state = SCENES.NIGHT
		SCENES.SLEEP:
			current_child = SLEEP_SCENE.instantiate()
			state = SCENES.SLEEP
		SCENES.DEBUG:
			current_child = DEBUG_SCENE.instantiate()
			state = SCENES.DEBUG
	self.add_child(current_child)

func exit_scene() -> void:
	# Get data from each scene here before loading the next
	match state:
		SCENES.MAIN_MENU:
			pass
		SCENES.DAY:
			#ingredients = current_child.ingredients #TODO sam, dis broken 
			#purchaseables = current_child.purchaseables #TODO sam, dis broken too
			money = current_child.money
		SCENES.NIGHT:
			pass
	if current_child != null:
		current_child.queue_free()

func get_save() -> Dictionary:
	var save_dict = {
		"version" : 0.0,
		"state" : state #may not be necessary unless we plan to make the game saveable from anywhere
	}
	for ingredient in ingredients:
		save_dict["ingredient_" + ingredient.name] = ingredient.count
	for purchaseable in purchaseables:
		save_dict["purchaseable_" + purchaseable.name] = purchaseable.count
	return save_dict

func save_game() -> void:
	var save_file = FileAccess.open(SAVE_FILE_LOCATION, FileAccess.WRITE)
	var json_string = JSON.stringify(get_save())
	save_file.store_line(json_string)

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE_LOCATION):
		return # no save file found
	var save_file = FileAccess.open(SAVE_FILE_LOCATION, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
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

extends Node

const DEBUG_SCENE = preload("res://dev/debug_stuff.tscn")

const DAY_MAIN_SCENE = preload("res://dev/DayTime/day_main.tscn")
const DAWN_SCENE = preload("res://dev/NightTime/scenes/Dawn.tscn")
const DUSK_SCENE = preload("res://dev/NightTime/scenes/Dusk.tscn")
const NIGHT_SCENE = preload("res://dev/NightTime/scenes/Night.tscn")
const SLEEP_SCENE = preload("res://dev/NightTime/scenes/Sleep.tscn")
const ACTION_SCENE = preload("res://dev/NightTime/scenes/Action.tscn")

const ROLL_TEMPLATE = preload("res://dev/NightTime/scenes/Templates/roll.tscn")

const SAVE_FILE_LOCATION = "user://savegame.save"

enum SCENES {NULL, MAIN_MENU, DAWN, DAY, DUSK, NIGHT, SLEEP, ACTION, DEBUG}
var state: SCENES = SCENES.NULL

var current_child: Node = null

# Day Time Data
var ingredients: Array
var purchaseables: Array
var money: int

#Night Time Data
var heat: float #police attention
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
		SCENES.ACTION:
			current_child = ACTION_SCENE.instantiate()
			state = SCENES.ACTION
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

func wait(amt:int):
	await get_tree().create_timer(amt).timeout #wait function ig

func roll(pass_chance: float):
	self.add_child(ROLL_TEMPLATE.instantiate())
	var roll_node = $Roll
	roll_node.chance = pass_chance
	await wait(4)
	var result = roll_node.stop()
	await wait(4)
	roll_node.queue_free()
	return true if (result) else false

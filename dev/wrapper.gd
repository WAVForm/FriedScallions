extends Node

const DEBUG_SCENE = preload("res://dev/debug_menu.tscn")

const DAY_MAIN_SCENE = preload("res://dev/DayTime/scenes/day_main.tscn")
const DAY_PARENT = preload("res://dev/DayTime/scenes/day_parent.tscn")
const DAWN_SCENE = preload("res://dev/NightTime/scenes/dawn.tscn")
const DUSK_SCENE = preload("res://dev/NightTime/scenes/dusk.tscn")
const NIGHT_SCENE = preload("res://dev/NightTime/scenes/night.tscn")
const SLEEP_SCENE = preload("res://dev/NightTime/scenes/sleep.tscn")
const ACTION_SCENE = preload("res://dev/NightTime/scenes/action.tscn")
const TEXT_EVENT_SCENE = preload("res://dev/NightTime/scenes/text_event.tscn")

const ROLL_TEMPLATE = preload("res://dev/NightTime/scenes/templates/roll_template.tscn")

const SAVE_FILE_LOCATION = "user://savegame.save"

var day = 1
enum SCENES {NULL, MAIN_MENU, DAWN, DAY, DAY_PARENT, DUSK, NIGHT, SLEEP, ACTION, TEXT_EVENT, DEBUG}
var state: SCENES = SCENES.NULL

var current_child: Node = null

# Day Time Data
var ingredients: Array[Ingredient]:
	get:
		return DayMain.ingredients
	set(new_ingredients):
		DayMain.ingredients = new_ingredients
var purchaseables: Array[Purchaseable]:
	get:
		return DayMain.purchaseables
	set(new_purchaseables):
		DayMain.purchaseables = new_purchaseables
var money: int:
	get:
		return DayMain.money
	set(new_money):
		DayMain.money = new_money

var popularity: float = 0.5
signal friendly_shop_entered
signal enemy_shop_entered

#Night Time Data
var slept: bool
var night_events = [[], []] # [PRIORITY QUEUE, LIST OF USED ACTIONS]
#TODO Store actions? Or, buffs/debuffs?

func _ready():
	change_scene(SCENES.DEBUG)

func change_scene(sceneid: SCENES) -> void:
	exit_scene()
	if state == SCENES.NIGHT: #if we're exiting the night scene, reset list of used actions to empty
		night_events[1] = []
	match sceneid:
		SCENES.DAWN:
			current_child = DAWN_SCENE.instantiate()
			state = SCENES.DAWN
		SCENES.DAY:
			current_child = DAY_MAIN_SCENE.instantiate()
			state = SCENES.DAY
		SCENES.DAY_PARENT:
			current_child = DAY_PARENT.instantiate()
			state = SCENES.DAY_PARENT
		SCENES.DUSK:
			current_child = DUSK_SCENE.instantiate()
			state = SCENES.DUSK
		SCENES.NIGHT:
			current_child = NIGHT_SCENE.instantiate()
			state = SCENES.NIGHT
		SCENES.SLEEP:
			current_child = SLEEP_SCENE.instantiate()
			state = SCENES.SLEEP
			day += 1
		SCENES.ACTION:
			current_child = ACTION_SCENE.instantiate()
			state = SCENES.ACTION
			day += 1
		SCENES.TEXT_EVENT:
			current_child = TEXT_EVENT_SCENE.instantiate()
			state = SCENES.TEXT_EVENT
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

func wait(amt:int):
	await get_tree().create_timer(amt).timeout #wait function ig

func roll(pass_chance: float):
	self.add_child(ROLL_TEMPLATE.instantiate())
	var roll_node = $roll
	roll_node.chance = pass_chance
	await wait(4)
	var result = roll_node.stop()
	if (day == 3):
		roll_node.rtext.text = "100%"
		roll_node.current = 100
		result = 1.0
	await wait(4)
	roll_node.queue_free()
	return true if (result) else false

func get_text_event():
	match day:
		1:
			change_scene(SCENES.TEXT_EVENT)
			current_child.set_text("Overnight you toiled at a new recipe for a pastry.", 2)
			purchaseables[0].count = 1
			purchaseables[0].unlocked = 1
		2:
			change_scene(SCENES.TEXT_EVENT)
			current_child.set_text("Overnight you toiled at a new recipe for a cake.", 2)
			purchaseables[3].count = 1
			purchaseables[3].unlocked = 1
			purchaseables[0].unlocked = 2
			purchaseables[4].unlocked = 1
		3:
			change_scene(SCENES.TEXT_EVENT)
			current_child.set_text("That new neighbor has to be stopped or else I'll go out of business!", 2)
		_:
			#No text event
			change_scene(SCENES.NIGHT)
			
func after_text_event():
	match day:
		3:
			change_scene(SCENES.NIGHT)
		_:
			change_scene(SCENES.SLEEP)

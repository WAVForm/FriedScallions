extends Node

var audio_handler: AudioStreamPlayer
var ceil = -12
var fade_delta = 0.0
var fade_started = false
const title_song = preload("res://dev/Audio/seriousv2.mp3")
const cafe_song = preload("res://dev/Audio/jazzyv1.mp3")
const button_sound = preload("res://dev/Audio/button_sound.wav")
const select_sound = preload("res://dev/Audio/select.wav")
const morning = preload("res://dev/Audio/morning_sound.mp3")
const night = preload("res://dev/Audio/night_sound.mp3")

const DAY_MAIN_SCENE = preload("res://dev/DayTime/scenes/day_main.tscn")
const DAY_PARENT = preload("res://dev/DayTime/scenes/day_parent.tscn")
const DAWN_SCENE = preload("res://dev/NightTime/scenes/dawn.tscn")
const DUSK_SCENE = preload("res://dev/NightTime/scenes/dusk.tscn")
const NIGHT_SCENE = preload("res://dev/NightTime/scenes/night.tscn")
const SLEEP_SCENE = preload("res://dev/NightTime/scenes/sleep.tscn")
const ACTION_SCENE = preload("res://dev/NightTime/scenes/action.tscn")
const TEXT_EVENT_SCENE = preload("res://dev/NightTime/scenes/text_event.tscn")
const TITLE_SCREEN = preload("res://dev/DayTime/scenes/title_screen.tscn")

const ROLL_TEMPLATE = preload("res://dev/NightTime/scenes/templates/roll_template.tscn")

const SAVE_FILE_LOCATION = "user://savegame.save"

var day = 1
enum SCENES {NULL, TITLE_SCREEN, DAWN, DAY, DAY_PARENT, DUSK, NIGHT, SLEEP, ACTION, TEXT_EVENT, DEBUG}
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

var popularity: float

signal friendly_shop_entered
signal enemy_shop_entered

#Night Time Data
var slept: bool
var night_events = [[], []] # [PRIORITY QUEUE, LIST OF USED ACTIONS]
#TODO Store actions? Or, buffs/debuffs?

func _ready():
	audio_handler = AudioStreamPlayer.new()
	audio_handler.stream = AudioStreamPolyphonic.new()
	self.add_child(audio_handler)
	audio_handler.play()
	
	change_scene(SCENES.TITLE_SCREEN)

func change_scene(sceneid: SCENES) -> void:
	exit_scene()
	if state == SCENES.NIGHT: #if we're exiting the night scene, reset list of used actions to empty
		night_events[1] = []
	match sceneid:
		SCENES.DAWN:
			current_child = DAWN_SCENE.instantiate()
			state = SCENES.DAWN
			play_audio()
			fade_in(1)
		SCENES.DAY:
			current_child = DAY_MAIN_SCENE.instantiate()
			state = SCENES.DAY
			play_audio()
			fade_in(0.01)
		SCENES.DAY_PARENT:
			current_child = DAY_PARENT.instantiate()
			state = SCENES.DAY_PARENT
		SCENES.DUSK:
			current_child = DUSK_SCENE.instantiate()
			state = SCENES.DUSK
			play_audio()
			fade_in(0.01)
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
		SCENES.TITLE_SCREEN:
			current_child = TITLE_SCREEN.instantiate()
			state = SCENES.TITLE_SCREEN
			play_audio()
			fade_in(0.01)
	self.add_child(current_child)

func exit_scene() -> void:
	# Get data from each scene here before loading the next
	match state:
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
	await wait(2)
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
			purchaseables[0].unlocked = 1
		2:
			change_scene(SCENES.TEXT_EVENT)
			current_child.set_text("Overnight you toiled at a new recipe for a cake.", 2)
			purchaseables[0].unlocked = 2
			purchaseables[3].unlocked = 1
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
			
func play_audio():
	audio_handler.stop()
	audio_handler.play()
	var poly = audio_handler.get_stream_playback()
	if state == SCENES.TITLE_SCREEN:
		poly.play_stream(title_song)
		current_child.get_node("MarginContainer/VBoxContainer/Play").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("MarginContainer/VBoxContainer/Options").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("MarginContainer/VBoxContainer/Quit").mouse_entered.connect(func(): poly.play_stream(button_sound))
		
		current_child.get_node("MarginContainer/VBoxContainer/Play").pressed.connect(func(): poly.play_stream(select_sound))
		current_child.get_node("MarginContainer/VBoxContainer/Options").pressed.connect(func(): poly.play_stream(select_sound))
		current_child.get_node("MarginContainer/VBoxContainer/Quit").pressed.connect(func(): poly.play_stream(select_sound))
	elif state == SCENES.DAWN:
		poly.play_stream(morning)
	elif state == SCENES.DUSK:
		poly.play_stream(night)
	elif state == SCENES.DAY:
		poly.play_stream(cafe_song)
		current_child.get_node("GameUI/ServeButton").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("GameUI/Quit").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("Camera").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("DayOverUI/EndDay").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("MorningUI/StartDay").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("day_parent/inside/trash_can").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("day_parent/inside/cake_station").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("day_parent/inside/pastry_station").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("day_parent/inside/coffee_station").mouse_entered.connect(func(): poly.play_stream(button_sound))
		current_child.get_node("day_parent/inside/tea_station").mouse_entered.connect(func(): poly.play_stream(button_sound))
		
		current_child.get_node("GameUI/ServeButton").pressed.connect(func(): poly.play_stream(select_sound))
		current_child.get_node("GameUI/Quit").pressed.connect(func(): poly.play_stream(select_sound))
		current_child.get_node("Camera").pressed.connect(func(): poly.play_stream(select_sound))
		current_child.get_node("DayOverUI/EndDay").pressed.connect(func(): poly.play_stream(select_sound))
		current_child.get_node("MorningUI/StartDay").pressed.connect(func(): poly.play_stream(select_sound))
		
		current_child.get_node("day_parent/inside/trash_can").input_event.connect(func(_c,event,_ep,_n,_s): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: poly.play_stream(select_sound))
		current_child.get_node("day_parent/inside/cake_station").input_event.connect(func(_c,event,_ep,_n,_s): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: poly.play_stream(select_sound))
		current_child.get_node("day_parent/inside/pastry_station").input_event.connect(func(_c,event,_ep,_n,_s): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: poly.play_stream(select_sound))
		current_child.get_node("day_parent/inside/coffee_station").input_event.connect(func(_c,event,_ep,_n,_s): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: poly.play_stream(select_sound))
		current_child.get_node("day_parent/inside/tea_station").input_event.connect(func(_c,event,_ep,_n,_s): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: poly.play_stream(select_sound))

func fade_in(fade_increase):
	if not fade_started:
		fade_delta = fade_increase
		audio_handler.volume_db = -60
		fade_started = true
	if audio_handler.volume_db < ceil:
		audio_handler.volume_db += fade_increase
	else:
		audio_handler.volume_db = ceil
		fade_started = false
		return
		
func _process(delta):
	if fade_started:
		fade_in(fade_delta)

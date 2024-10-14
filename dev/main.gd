extends Node2D

const debug_scene = preload("res://dev/debug_stuff.tscn")

const day_main_scene = preload("res://dev/DayTime/day_main.tscn")
const night_main_scene = preload("res://dev/NightTime/peter/Dusk.tscn")

var current_child = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enter_debug()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter_debug() -> void:
	if current_child != null:
		current_child.queue_free()
	current_child = debug_scene.instantiate()
	current_child.day_time.connect(enter_day)
	current_child.night_time.connect(enter_night)
	add_child(current_child)

func enter_day() -> void:
	if current_child != null:
		current_child.queue_free()
	current_child = day_main_scene.instantiate()
	current_child.day_exit.connect(enter_debug)
	add_child(current_child)

func enter_night() -> void:
	if current_child != null:
		current_child.queue_free()
	current_child = night_main_scene.instantiate()
	add_child(current_child)

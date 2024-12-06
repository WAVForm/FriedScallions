extends Node3D

class_name Inside

var highlight_mat = preload("res://dev/materials/highlight.tres")
var highlighted = []

@onready var floor = $floor
@onready var trash = $trash_can
@onready var cake = $cake_station
@onready var sandwich = $sandwich_station
@onready var coffee = $coffee_station
@onready var tea = $tea_station
@onready var player = $player
@onready var player_agent = $player/NavigationAgent3D as NavigationAgent3D

var player_speed = 5.0

enum STATIONS {NONE, TRASH, CAKE, SANDWICH, COFFEE, TEA}

signal station_reached(station_name:STATIONS)
var navigating = [false, STATIONS.NONE]

func _ready():
	floor.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.NONE) elif event is InputEventMouse: unhighlight_all())
	trash.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.TRASH) elif event is InputEventMouse: highlight(trash))
	sandwich.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.SANDWICH) elif event is InputEventMouse: highlight(sandwich))
	cake.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.CAKE) elif event is InputEventMouse: highlight(cake))
	coffee.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.COFFEE) elif event is InputEventMouse: highlight(coffee))
	tea.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.TEA) elif event is InputEventMouse: highlight(tea))

func _physics_process(delta):
	if navigating[0]:
		var dir = (player_agent.get_next_path_position()-player.global_position).normalized()
		player.velocity = player_speed * dir
		player.move_and_slide()
		if player_agent.is_target_reached():
			station_reached.emit(navigating[1])
			navigating[0] = false

func navigate_to(pos: Vector3, station:STATIONS):
		player_agent.set_target_position(pos)
		navigating = [true, station]

func highlight(object: Area3D):
	unhighlight_all()
	object.get_node("model").material_override = highlight_mat
	highlighted.append(object)

func unhighlight_all():
	for object in highlighted:
		object.get_node("model").material_override = null

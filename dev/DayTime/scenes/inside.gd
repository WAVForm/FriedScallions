extends Node3D

class_name Inside

var highlight_mat = preload("res://dev/materials/highlight.tres")

@onready var floor = $floor as Area3D
@onready var trash = $trash_can as Area3D
@onready var cake = $cake_station as Area3D
@onready var sandwich = $pastry_station as Area3D
@onready var coffee = $coffee_station as Area3D
@onready var tea = $tea_station as Area3D
@onready var player = $player
@onready var player_agent = $player/NavigationAgent3D as NavigationAgent3D

var player_speed = 5.0

enum STATIONS {NONE, TRASH, CAKE, SANDWICH, COFFEE, TEA}

signal station_reached(station_name:STATIONS)
var navigating = [false, STATIONS.NONE]

func _ready():
	floor.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.NONE))
	trash.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.TRASH))
	trash.mouse_entered.connect(func(): highlight(trash))
	trash.mouse_exited.connect(func(): unhighlight(trash))
	sandwich.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.SANDWICH) )
	sandwich.mouse_entered.connect(func(): highlight(sandwich))
	sandwich.mouse_exited.connect(func(): unhighlight(sandwich))
	cake.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.CAKE))
	cake.mouse_entered.connect(func(): highlight(cake))
	cake.mouse_exited.connect(func(): unhighlight(cake))
	coffee.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.COFFEE))
	coffee.mouse_entered.connect(func(): highlight(coffee))
	coffee.mouse_exited.connect(func(): unhighlight(coffee))
	tea.input_event.connect(func(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int): if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1: navigate_to(event_position, STATIONS.TEA))
	tea.mouse_entered.connect(func(): highlight(tea))
	tea.mouse_exited.connect(func(): unhighlight(tea))

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
	object.get_node("model").material_override = highlight_mat

func unhighlight(object: Area3D):
	object.get_node("model").material_override = null

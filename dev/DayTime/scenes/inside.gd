extends Node3D

@onready var floor = $floor
@onready var trash = $trash_can
@onready var cake = $cake_station
@onready var sandwich = $sandwich_station
@onready var coffee = $coffee_station
@onready var tea = $tea_station
@onready var player = $player

var move_target = Vector3(0, 0, 0)

signal player_move(new_pos:Vector3)

func _ready():
	floor.input_event.connect()
	trash.input_event.connect()
	sandwich.input_event.connect()
	coffee.input_event.connect()
	tea.input_event.connect()

func _physics_process(delta):
	pass

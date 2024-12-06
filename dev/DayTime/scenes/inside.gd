extends Node3D

@onready var floor = $floor
@onready var trash = $trash_can
@onready var cake = $cake_station
@onready var sandwich = $sandwich_station
@onready var coffee = $coffee_station
@onready var tea = $tea_station
@onready var player = $player
@onready var player_agent = $player/NavigationAgent3D

var player_speed = 5.0

func _ready():
	floor.input_event.connect(extract_click_location)
	trash.input_event.connect(extract_click_location)
	sandwich.input_event.connect(extract_click_location)
	cake.input_event.connect(extract_click_location)
	coffee.input_event.connect(extract_click_location)
	tea.input_event.connect(extract_click_location)

func _physics_process(delta):
	if not player_agent.is_target_reached():
		var dir = (player_agent.get_next_path_position()-player.global_position).normalized()
		player.velocity = player_speed * dir
		player.move_and_slide()

func extract_click_location(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		player_agent.set_target_position(event_position)

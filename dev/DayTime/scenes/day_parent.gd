extends Node3D
var person = preload("res://dev/DayTime/scenes/person.tscn")
var people = 0

@onready var friendly = $friendly as Node3D
@onready var enemy = $enemy as Node3D
@onready var inside_camera = $inside_camera as Camera3D
@onready var outside_camera = $outside_camera as Camera3D

var spawn_delay = [1.5, 3.5] #current time, delay until next person should try to spawn
var spawn_chance = 0.25 #chance for person to spawn after delay
var can_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_spawn:
		if spawn_delay[0] < spawn_delay[1]:
			spawn_delay[0] += delta
		else:
			spawn_delay[0] = 0.0
			spawn_person()

func _input(event):
	if event.is_action_pressed("ui_page_up"):
		spawn_person()

func spawn_person(side:int=2):
	match side:
		0:
			var new_person = person.instantiate()
			new_person.name = "person" + str(people)
			$enemy.add_child(new_person)
			new_person.start(people)
			people += 1
		1:
			var new_person = person.instantiate()
			new_person.name = "person" + str(people)
			$friendly.add_child(new_person)
			new_person.start(people)
			people += 1
		_:
			side = randi() % 2
			spawn_person(side)

func set_current_path(p:Person):
	var path = null
	match p.state:
		Person.STATES.TO_ADVERT:
			path = p.side.get_node("to_advert") as Path3D
		Person.STATES.CROSSING:
			path = p.side.get_node("crossing") as Path3D
		Person.STATES.TO_LINE:
			path = p.side.get_node("to_line") as Path3D
		Person.STATES.IN_LINE:
			path = p.side.get_node("line") as Path3D
		Person.STATES.TO_REGISTER:
			if p.side == friendly:
				WRAPPER.friendly_shop_entered.emit() #TODO bandaid visual fix, redo this later
			elif p.side == enemy:
				WRAPPER.enemy_shop_entered.emit() #TODO bandaid visual fix, redo this later
			p.visible = false
			
			path = p.side.get_node("to_register") as Path3D
		Person.STATES.FROM_REGISTER:
			path = p.side.get_node("from_register") as Path3D
		Person.STATES.LEAVING:
			path = p.side.get_node("leave") as Path3D
		_:
			p.path_len = 0
			p.current_path = path
			return
	p.path_len = path.curve.get_baked_length()
	p.current_path = path
	
func switch_side(p:Person):
	p.side = friendly if p.side == enemy else enemy

func switch_camera() -> void:
	if inside_camera.current:
		outside_camera.current = true
	else:
		inside_camera.current = true

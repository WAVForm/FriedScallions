extends Node3D
var person = preload("res://dev/DayTime/scenes/person.tscn")
var people = 0

@onready var friendly = $friendly as Node3D
@onready var enemy = $enemy as Node3D

var spawn_delay = [10.0, 10.0] #current time, delay until next person should try to spawn
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

func set_current_path(person:Person):
	var path = null
	match person.state:
		Person.STATES.TO_ADVERT:
			path = person.side.get_node("to_advert") as Path3D
		Person.STATES.CROSSING:
			path = person.side.get_node("crossing") as Path3D
		Person.STATES.TO_LINE:
			path = person.side.get_node("to_line") as Path3D
		Person.STATES.IN_LINE:
			path = person.side.get_node("line") as Path3D
		Person.STATES.TO_REGISTER:
			path = person.side.get_node("to_register") as Path3D
		Person.STATES.FROM_REGISTER:
			path = person.side.get_node("from_register") as Path3D
		Person.STATES.LEAVING:
			path = person.side.get_node("leave") as Path3D
		_:
			person.len = 0
			person.current_path = path
			return
	person.len = path.curve.get_baked_length()
	person.current_path = path
	
func switch_side(person:Person):
	person.side = friendly if person.side == enemy else enemy

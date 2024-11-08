extends Node3D
var person = preload("res://dev/DayTime/scenes/person.tscn")
var people = 0

var spawn_delay = [0.0, 1] #current time, delay until next person should try to spawn
var spawn_chance = 0.25 #chance for person to spawn after delay
var can_spawn = true
var door_delay = [0.0, 3.0] #current time, delay until person can enter door
signal can_enter

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
		
	if door_delay[0] < door_delay[1]:
		door_delay[0] += delta
	else:
		door_delay[0] = 0.0
		can_enter.emit()

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

extends Node3D
var person = preload("res://dev/DayTime/scenes/person.tscn")
var people = 0
var time = 0
var delay = 5 #seconds until next person should spawn
var spawn_chance = 0.1 #chance for person to spawn after delay

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time >= delay and randf_range(0.0, 1.0) <= spawn_chance:
		spawn_person()
		time = 0
	else:
		time += delta

func spawn_person(side:int=2):
	var new_person = person.instantiate()
	new_person.name = "person#" + str(people)
	match side:
		0:
			$enemy.add_child(new_person)
			new_person.start()
			people += 1
		1:
			$friendly.add_child(new_person)
			new_person.start()
			people += 1
		_:
			side = randi() % 2
			spawn_person(side)

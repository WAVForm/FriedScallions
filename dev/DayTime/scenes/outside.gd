extends Node3D
var person = preload("res://dev/DayTime/scenes/person.tscn")
var people:Array = []
var time = 0
var delay = 1 #seconds until next person should spawn
var spawn_chance = 0.25 #chance for person to spawn after delay

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if time >= delay:
	#	if randf_range(0.0, 1.0) <= spawn_chance:
	#		spawn_person()
	#	time = 0
	#else:
	#	time += delta
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		spawn_person()

func spawn_person(side:int=2):
	match side:
		0:
			var new_person = person.instantiate()
			new_person.name = "person" + str(people.size())
			$enemy.add_child(new_person)
			new_person.start(people.size())
			people.append(new_person)
		1:
			var new_person = person.instantiate()
			new_person.name = "person" + str(people.size())
			$friendly.add_child(new_person)
			new_person.start(people.size())
			people.append(new_person)
		_:
			side = randi() % 2
			spawn_person(side)

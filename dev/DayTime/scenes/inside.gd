extends Node3D

@onready var to_register:Path3D = $to_register
@onready var from_register:Path3D = $from_register
var person = preload("res://dev/DayTime/scenes/person.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		spawn_person()
		
func spawn_person():
	var p = person.instantiate()
	self.add_child(p)
	p.current_path = to_register
	p.started = true
	p.moving = true

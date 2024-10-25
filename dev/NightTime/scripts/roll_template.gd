extends Control

var roll_delay = 50 #higher number to decrease flashing
var roll_i = 0
var chance = 0.0
var rolling = false
var current = 0
@onready var bg:ColorRect = $roll_bg
@onready var rtext:Label = $roll_text

func _ready():
	rolling = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if rolling and roll_i % roll_delay == 0:
		current = randi()%100
		rtext.text = str(current) + "%"
	roll_i += 1
	if current/100.0 < 1.0-chance:
		bg.color = Color.RED
	elif current/100.0 >= 1.0 - chance:
		bg.color = Color.GREEN

func stop():
	rolling = false
	return 1.0-chance < current/100.0 #is the roll higher than the pass chance

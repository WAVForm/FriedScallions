extends Control

@onready var bg_gradient = Gradient.new()
var chance = 0.0
var rolling = false
@onready var bg = $RollBG
@onready var text = $RollText

func _ready():
	rolling = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rolling:
		current = randi()%100
		text.text = str(current) + "%"
		
	
func stop():
	rolling = false
	return chance < int(text.text)/100.0 #is the roll higher than the pass chance

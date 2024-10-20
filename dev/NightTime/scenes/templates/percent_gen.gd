extends Control

var roll_demo = 1
var rolling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#roll()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rolling:
		var roll_num = gen_num()
		show_number(roll_num)
	#roll()
	#$RandNum.text = str(int(delta * 1000))
	#For demo purposes only
	#if roll_demo % 30 > 0:
		#roll()
		#roll_demo += 1
	#else:
		#stop()

func roll():
	#Prints a random integer between 0 and 100.
	rolling = true

func show_number(num):
	var num_text = "%0*d" % [2, num]
	$RandPercent.text = num_text + "%"
	$RandPercent.show()
	#print ("Mason was here " + num_text)
	
func stop():
	rolling = false
	var num = gen_num()
	show_number(num)
	return num/100

func gen_num():
	var num = randi() % 101
	return num
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if rolling:
			stop()
		else:
			roll()

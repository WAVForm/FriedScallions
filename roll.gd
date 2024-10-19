extends Control

var roll_demo = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stop()
	#roll()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#roll()
	#$RandNum.text = str(int(delta * 1000))
	#For demo purposes only
	if roll_demo % 30 > 0:
		#roll()
		roll_demo += 1
	else:
		stop()

func roll():
	#Prints a random integer between 0 and 100.
	var roll_num = gen_num()
	show_number(roll_num)

func show_number(num):
	var num_text = "%0*d" % [2, num]
	$RandNum.text = num_text
	$RandNum.show()
	#print ("Mason was here " + num_text)
	
func stop():
	var num = gen_num()
	show_number(num)
	return num/100

func gen_num():
	var num = randi() % 101
	return num
	

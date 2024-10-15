extends BaseButton

class_name ConfirmButton

var fill_color = Color.GRAY
var confirm_delay = 2 #seconds
var fill_progress = false
@onready var progress_bar = $confirm_progress

signal confirmed

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.modulate = fill_color
	
	self.button_down.connect(func():fill_progress=true)
	self.button_up.connect(func():fill_progress=false)

func _process(delta):
	if fill_progress:
		progress_bar.value += (progress_bar.max_value/(confirm_delay))*delta
	elif progress_bar.value > 0:
		if progress_bar.value > confirm_delay:
			progress_bar.value -= (progress_bar.max_value*delta)/(confirm_delay/progress_bar.value)
		else:
			progress_bar.value -= (progress_bar.max_value*delta)
	if(progress_bar.value>=progress_bar.max_value): 
		confirmed.emit()

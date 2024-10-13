extends TextureButton

var confirm_delay = 5 #seconds
var fill_progress = false
@onready var progress_bar = $confirm_progress

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.modulate = self.get_parent().get_node("chance_background").color #make confirm bar same color as chance
	
	self.button_down.connect(func():fill_progress=true)
	self.button_up.connect(func():fill_progress=false)

func _process(delta):
	if fill_progress:
		progress_bar.value += (progress_bar.max_value*delta)/(confirm_delay+1)
	elif progress_bar.value > 0:
		if progress_bar.value > confirm_delay:
			progress_bar.value -= (progress_bar.max_value*delta)/(confirm_delay/progress_bar.value)
		else:
			progress_bar.value -= (progress_bar.max_value*delta)

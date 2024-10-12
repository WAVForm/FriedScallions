extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = Button.new()
	button.text = "Click me"
	button.button_down.connect(self._button_down)
	button.button_up.connect(self._button_up)
	add_child(button)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if self.is_button_down:
		#self._button_pressed()
	pass
	
func _button_down():
	print("What")
	self._start_timer()
	
func _button_up():
	pass
	
func _start_timer():
	var time_in_seconds = 3
	self._display_confirmation_wait_animation()
	await get_tree().create_timer(time_in_seconds).timeout
	
func _display_confirmation_wait_animation():
	print("Confirmation time up. Sending you to night time activities.")

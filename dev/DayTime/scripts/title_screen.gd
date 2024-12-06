extends Control

@onready var bg = $"Background Image" as TextureRect
@onready var buttons = $MarginContainer as MarginContainer
var fade_timer = Timer.new()
var started = false
var bg_faded = false
var buttons_in = false
var skipped = false

func _ready():
	bg.modulate = Color.BLACK
	buttons.position = Vector2(-200, 290)
	fade_timer.autostart = true
	fade_timer.one_shot = true
	self.add_child(fade_timer)
	fade_timer.start(2.5)
	
func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed() and (not bg_faded or not buttons_in):
		skipped = true
		bg.modulate = Color.WHITE
		buttons.position = Vector2(42, 290)
		
func _process(delta):
	if not skipped:
		if (fade_timer.is_stopped()):
			if not bg_faded:
				bg_faded = true
				fade_timer.start(2.5)
			elif not buttons_in:
				buttons_in = true
		else:
			if not bg_faded:
				bg.modulate = Color.BLACK.lerp(Color.WHITE, 1-(fade_timer.time_left/fade_timer.wait_time))
			elif not buttons_in:
				buttons.position = Vector2(-200,290).lerp(Vector2(42, 290), 1-(fade_timer.time_left/fade_timer.wait_time))

func _on_play_pressed() -> void:
	WRAPPER.change_scene(WRAPPER.SCENES.DAWN)

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()

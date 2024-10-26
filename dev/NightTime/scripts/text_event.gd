extends Control

@onready var event_text: RichTextLabel = $text
var readable = false
var text = null
var text_progress = 0.0
var text_progress_time = 4 #default, change in wrapper to reflect time needed to read

func set_text(text, time=4):
	event_text.text = "[center]" + text + "[/center]"
	text_progress_time = time
	readable = true
	
func _process(delta):
	if not readable:
		pass
	if text_progress < 1.0:
		text_progress += 1.0/text_progress_time * delta
		event_text.visible_ratio = text_progress
	else:
		event_text.visible_ratio = 1.0
		await WRAPPER.wait(4)
		WRAPPER.after_text_event()

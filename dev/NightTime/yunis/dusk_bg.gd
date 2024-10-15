extends ColorRect

var time_limit = 10
var progress = 0.0

func _process(delta):
	#if timed out, go to sleep
	if progress < 1.0:
		progress += (1.0/time_limit)*delta
		self.material.set_shader_parameter("progress", progress)
	else:
		self.get_parent().get_node("button_container").get_node("sleep_confirm").confirmed.emit()
	pass

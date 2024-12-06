extends ProgressBar

func _process(delta: float) -> void:
	visible = value > 0.0

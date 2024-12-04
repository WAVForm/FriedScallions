extends Sprite3D

var _serving: bool = false
var _delay: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _serving:
		if _delay > 0:
			_delay -= delta
		else:
			position.z += 10.0 * delta
			if position.z > 3:
				queue_free()

func serve(delay: float) -> void:
	_serving = true
	_delay = delay

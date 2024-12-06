extends Sprite3D

var _serving = [false, Vector3(0,0,0)]
var _delay: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _serving[0]:
		if _delay > 0:
			_delay -= delta
		else:
			global_position = global_position.lerp(_serving[1], delta*10)
			if global_position.distance_squared_to(_serving[1]) < 0.1:
				queue_free()

func serve(delay: float, pos: Vector3) -> void:
	_serving = [true, pos]
	_delay = delay

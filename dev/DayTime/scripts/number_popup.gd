extends Label

var t: float = 0
var delay: float = 0

func _ready() -> void:
	position.x += randi_range(-3, 3)
	position.y += randi_range(-3, 3)

func _process(delta: float) -> void:
	if delay <= 0:
		visible = true
		t += delta
		position.y -= 25.0 * delta
		if t >= 0.25:
			self_modulate = Color(1.0, 1.0, 1.0, 1.0 - (4.0 * (t - 0.25)))
		if t >= 0.5:
			queue_free()
	else:
		visible = false
		delay -= delta

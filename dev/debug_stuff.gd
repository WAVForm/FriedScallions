extends Node2D

signal day_time()
signal night_time()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_day_time_pressed() -> void:
	day_time.emit()


func _on_night_time_pressed() -> void:
	night_time.emit()

extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_dawn_pressed():
	WRAPPER.change_scene(WRAPPER.SCENES.DAWN)

func _on_dusk_pressed():
	WRAPPER.change_scene(WRAPPER.SCENES.DUSK)

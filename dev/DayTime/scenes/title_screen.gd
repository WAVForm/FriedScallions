extends Control

func _on_play_pressed() -> void:
	WRAPPER.change_scene(WRAPPER.SCENES.DAWN)

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()

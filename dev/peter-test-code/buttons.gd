extends VBoxContainer

var Button2InProgress = false

func _on_button_1_button_down():
	var holdLongEnough = false
	while !Input.is_action_just_released("Mouse1") and $Button1/ProgressBar.value < 100:
		await get_tree().create_timer(0.01).timeout
		
		$Button1/ProgressBar.value += 1
		
		if $Button1/ProgressBar.value == 100:
			holdLongEnough = true
	
	if holdLongEnough:
		get_tree().change_scene_to_file("res://Night.tscn")
	
	$Button1/ProgressBar.value = 0
		

func _on_button_2_button_down():
	
	if Button2InProgress:
		return
	
	var holdLongEnough = false
	
	Button2InProgress = true
	while !Input.is_action_just_released("Mouse1") and $Button2/ProgressBar.value < 100:
			
		await get_tree().create_timer(0.01).timeout
		
		$Button2/ProgressBar.value += 1
		
		if $Button2/ProgressBar.value == 100:
			holdLongEnough = true

	if holdLongEnough:
		get_tree().change_scene_to_file("res://Sleep.tscn")
	
	$Button2/ProgressBar.value = 0
	Button2InProgress = false

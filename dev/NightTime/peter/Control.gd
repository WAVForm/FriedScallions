extends Control

func _ready():
	$MenuButtonFile.get_popup().add_item("Open File")
	$MenuButtonFile.get_popup().add_item("Save as File")
	$MenuButtonFile.get_popup().add_item("Quit")

func _on_item_pressed(id):
	var item_name = $MenuButtonFile.get_popup().get_item_text(id)
	print(item_name + "pressed")

func _on_open_file_pressed():
	$FileDialog.popup()

func _on_save_file_pressed():
	$SaveFileDialog.popup()
	
func _on_file_dialog_file_selected(path: String):
	print(path)
	var f = FileAccess.open(path, FileAccess.READ)
	$TextEdit.text = f.get_as_text()
	f.close()

extends HBoxContainer

@onready var name_label = $Name
@onready var value_label = $Value

func update_display(stat_name: String, stat_value: String):
	name_label.text = stat_name
	value_label.text = stat_value

extends ColorRect

@onready var name_label = $container/Name
@onready var value_label = $container/Value

func update_display(stat_name: String, stat_value: String):
	name_label.text = stat_name
	value_label.text = stat_value

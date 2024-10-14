extends BoxContainer

var actions_amt = 3 #how many actions?

func _ready():
	self.get_parent().get_node("back_to_dusk").confirmed.connect(func(): get_tree().change_scene_to_file("res://dev/NightTime/peter/Dusk.tscn"))
	for i in actions_amt:
		var aspect_ratio = AspectRatioContainer.new()
		aspect_ratio.ratio = 2
		aspect_ratio.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		self.add_child(aspect_ratio)
		aspect_ratio.add_child(load("res://dev/NightTime/yunis/action.tscn").instantiate())

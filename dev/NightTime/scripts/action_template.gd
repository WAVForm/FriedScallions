extends Panel

#actions
#current action
var action

#nodes
@onready var title_node = $action_title as Label
@onready var desc_node = $action_description as Label
@onready var chance_color = $chance_background as ColorRect
@onready var chance_percent = $chance_background/chance_percentage as Label
@onready var chance_reward_icon = $chance_background/chance_reward_icon as TextureRect
@onready var confirm_button = $confirm_button as ConfirmButton

func _ready():
	action = Action.random()
	set_nodes() #set nodes based on selected action
	confirm_button.confirmed.connect(func():
		var result = await WRAPPER.roll(action.chance)
		if (result):
			action.apply_reward()
		WRAPPER.change_scene(WRAPPER.SCENES.ACTION)
	)

func set_nodes():
	title_node.text = action.title
	desc_node.text = action.desc
	chance_percent.text = str(int(action.chance*100)) + "%"
	
	#set icons
	match (action.reward):
		Action.Rewards.Money:
			chance_reward_icon.texture = load("res://dev/NightTime/images/dollar.svg")
		_:
			chance_reward_icon.texture = load("res://dev/NightTime/images/check.svg")
	
	set_colors()

func set_colors():
	#set percentage color
	var chance_gradient = Gradient.new()
	chance_gradient.add_point(0.0, Color.RED)
	chance_gradient.add_point(0.999, Color.GREEN)
	#Gradient is broken...extremes (0.0 & 1.0) don't work for whatever reason
	if (action.chance >= 1.0):
		chance_color.color = Color.GREEN
	elif(action.chance <= 0.0):
		chance_color.color = Color.RED
	else:
		chance_color.color = chance_gradient.sample(action.chance)

	chance_reward_icon.self_modulate = Color(Color.BLACK,0.1)

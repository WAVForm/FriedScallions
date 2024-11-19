extends Panel

class_name ActionTemplate

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

func populate():
	if WRAPPER.night_events[0].size() != 0: #priority queue not empty
		action = WRAPPER.night_events[0].front()
		WRAPPER.night_events[0].pop_front()
	else: #it is empty
		action = Action.random()
		while action in WRAPPER.night_events[1]:
			action = Action.random()
		WRAPPER.night_events[1].append(action)
	action.check_and_add_tree_siblings()
	set_nodes() #set nodes based on selected action
	confirm_button.confirmed.connect(func():
		var result = await WRAPPER.roll(action.chance)
		if (result):
			action.add_next(true)
			print("Got reward")
			action.apply_reward()
			WRAPPER.change_scene(WRAPPER.SCENES.ACTION)
		else:
			action.add_next(false)
			print("No reward")
			WRAPPER.change_scene(WRAPPER.SCENES.DAWN)
	)

func set_nodes():
	title_node.text = action.title
	desc_node.text = action.desc
	chance_percent.text = str(int(action.chance*100)) + "%"
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

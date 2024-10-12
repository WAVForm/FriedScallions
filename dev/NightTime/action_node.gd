extends Panel

#actions
var premade_actions = [
	Action.new("Break register", "You attempt to break the register. Some money might fall out if you succeed, but police would be notified if you fail.", 0.1, Action.Rewards.Money, Action.Risks.Police)
]
#current action
var action

#nodes
@onready var title_node = $action_title as Label
@onready var desc_node = $action_description as Label
@onready var chance_color = $chance_background as ColorRect
@onready var chance_percent = $chance_background/chance_percentage as Label
@onready var chance_reward_icon = $chance_background/chance_reward_icon as TextureRect
@onready var chance_risk_icon = $chance_background/chance_risk_icon as TextureRect
@onready var button_node = $action_button as Button

func _ready():
	var rand_index = randi() % premade_actions.size()
	action = premade_actions[rand_index]
	set_nodes()
	
#testing
var time = 0
var i = 0.01
var testing_flag = true
func _process(_delta):
	if(testing_flag):
		if time >= 250:
			if action.chance >= 1.0 or action.chance <= 0.0:
				i *= -1
			action.chance += i
			set_nodes()
			time = 0
		time += 1

func set_nodes():
	title_node.text = action.title
	desc_node.text = action.desc
	chance_percent.text = str(int(action.chance*100)) + "%"
	
	#set icons
	match (action.reward):
		Action.Rewards.Money:
			chance_reward_icon.texture = load("res://dev/img/dollar.svg")
		_:
			chance_reward_icon.texture = load("res://dev/img/check.svg")
	
	match (action.risk):
		Action.Risks.Police:
			chance_risk_icon.texture = load("res://dev/img/police.svg")
		_:
			chance_risk_icon.texture = load("res://dev/img/exclamation.svg")
	
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
	
	#set icon colors based on chance
	var icon_gradient = Gradient.new()
	icon_gradient.add_point(0.0, Color(Color.BLACK,0.0))
	icon_gradient.add_point(0.999, Color(Color.BLACK,1.0))
	#Gradient is broken...extremes (0.0 & 1.0) don't work for whatever reason
	if (action.chance >= 1.0):
		chance_reward_icon.self_modulate = Color(Color.BLACK,1.0)
		chance_risk_icon.self_modulate = Color(Color.BLACK,0.0)
	elif(action.chance <= 0.0):
		chance_reward_icon.self_modulate = Color(Color.BLACK,0.0)
		chance_risk_icon.self_modulate = Color(Color.BLACK,1.0)
	else:
		chance_reward_icon.self_modulate = icon_gradient.sample(action.chance)
		chance_risk_icon.self_modulate = icon_gradient.sample(1.0-action.chance)

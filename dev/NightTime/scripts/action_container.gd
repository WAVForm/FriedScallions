extends BoxContainer

var actions_amt = 3 #how many actions?

var action_temp = preload("res://dev/NightTime/scenes/templates/action_template.tscn")
@onready var sleep_confirm = $"../sleep_confirm"

func _ready():
	if(WRAPPER.day == 3):
		day_three()
	else:
		sleep_confirm.confirmed.connect(func(): WRAPPER.change_scene(WRAPPER.SCENES.SLEEP))
		for i in actions_amt:
			create_action()

func create_action():
	var aspect_ratio = AspectRatioContainer.new() #create action holder, maintain aspect ratio of action template
	aspect_ratio.ratio = 2 #make sure it's wider than it is tall
	aspect_ratio.size_flags_horizontal = Control.SIZE_EXPAND_FILL #expand to fill the box container
	self.add_child(aspect_ratio) #put action holder in box container
	var template = action_temp.instantiate() as ActionTemplate
	template.ready.connect(func(): template.populate())
	aspect_ratio.add_child(template) #place action into action holder

func day_three():
	var aspect_ratio = AspectRatioContainer.new() #create action holder, maintain aspect ratio of action template
	aspect_ratio.ratio = 2 #make sure it's wider than it is tall
	aspect_ratio.size_flags_horizontal = Control.SIZE_EXPAND_FILL #expand to fill the box container
	self.add_child(aspect_ratio) #put action holder in box container
	var template = action_temp.instantiate() as ActionTemplate
	template.ready.connect(func():
		template.populate()
		template.action = Action.STEAL_INGREDIENTS
		template.set_nodes()
	)
	aspect_ratio.add_child(template) #place action into action holder
	
	var aspect_ratio2 = AspectRatioContainer.new() #create action holder, maintain aspect ratio of action template
	aspect_ratio2.ratio = 2 #make sure it's wider than it is tall
	aspect_ratio2.size_flags_horizontal = Control.SIZE_EXPAND_FILL #expand to fill the box container
	self.add_child(aspect_ratio2) #put action holder in box container
	var template2 = action_temp.instantiate() as ActionTemplate
	template2.ready.connect(func():
		template2.populate()
		template2.action = Action.BREAK_REGISTER
		template2.set_nodes()
	)
	aspect_ratio2.add_child(template2) #place action into action holder

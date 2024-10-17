extends BoxContainer

var actions_amt = 3 #how many actions?

var action_temp = preload("res://dev/NightTime/yunis/action.tscn")
@onready var sleep_confirm = $"../sleep_confirm"

func _ready():
	sleep_confirm.confirmed.connect(func(): WRAPPER.change_scene(WRAPPER.SCENES.SLEEP))
	for i in actions_amt:
		var aspect_ratio = AspectRatioContainer.new() #create action holder, maintain aspect ratio of action template
		aspect_ratio.ratio = 2 #make sure it's wider than it is tall
		aspect_ratio.size_flags_horizontal = Control.SIZE_EXPAND_FILL #expand to fill the box container
		self.add_child(aspect_ratio) #put action holder in box container
		aspect_ratio.add_child(action_temp.instantiate()) #place action into action holder
		
		var confirm = aspect_ratio.get_child(0).get_node("confirm_button") as ConfirmButton #get the confirm button of action
		#confirm.confirmed.connect() #what to do when confirmed?
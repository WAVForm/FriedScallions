extends Resource

class_name Action

#action variables
var title: String
var desc: String
var chance: float
var reward: Reward

#for decision trees
var next_fail:Action = null
var next_pass:Action = null

func _init(arg1, p_desc:String = "", p_chance:float = 0.0, p_reward:Reward= Reward.NONE, p_n_fail:Action = null, p_n_pass:Action = null):
	if arg1 is Action:
		title = arg1.title
		desc = arg1.desc
		chance = arg1.chance
		reward = arg1.reward
		next_fail = arg1.next_fail
		next_pass = arg1.next_pass
	else:
		title = arg1
		desc = p_desc
		chance = clamp(p_chance, 0.0, 1.0)
		reward = p_reward
		next_fail = p_n_fail
		next_pass = p_n_pass


func apply_reward():
	#called when action roll passed. Apply multiply based on difficulty
	reward.apply(chance)
	
func add_next(passed:bool):
	if passed:
		if next_pass != null:
			if next_pass == REPEAT:
				WRAPPER.night_events[0].append(self)
			else:
				WRAPPER.night_events[0].append(next_pass)
	else:
		if next_fail != null:
			if next_fail == REPEAT:
				WRAPPER.night_events[0].append(self)
			else:
				WRAPPER.night_events[0].append(next_fail)
				
func check_and_add_tree_siblings():
	for tree in decision_trees:
		if self in tree:
			WRAPPER.night_events[1].append_array(tree)
	

static func random():
	return action_choices[randi()%action_choices.size()]

#Premade Actions

static var STEAL_INGREDIENTS = Action.new("Steal ingredients", "The stock at your store is getting a little low, maybe the neighbor won't mind.", 0.5, Reward.RANDOM_INGREDIENT)
static var BREAK_REGISTER = Action.new("Break register", "You attempt to break the register. Some money might fall out if you succeed.", 0.1, Reward.RANDOM_MONEY)

#Trees
static var REPEAT = Action.new("REPEAT", "REPEAT", 1.0, Reward.NONE)

#Tree 1: Delivery Crew?
static var t1e3 = Action.new("", "Upon sharing some good cake and coffee with the crew, they let you take some of the rivals goods, as both a gesture of gratitude and a well deserved 'shipping mistake' for your rival.", 1.0, Reward.random_from_tier(3)) #random tier 3 reward
static var t1e2 = Action.new("", "You find out about some financial disputes between the rival and supplier and leak it, causing some drama online.", 1.0, Reward.new([Reward.TYPES.POPULARITY], [0.5])) #TODO how much pop?
static var t1e1 = Action.new("", "Strike up a conversation with the rival's supplier delivery crew.", 0.2, Reward.NONE, t1e2, t1e3) #tree 1, event 1
static var t1 = [t1e1, t1e2, t1e3]
#Tree 2: Paranormal?
static var t2e3 = Action.new("", "The rival gets a shipment of ingredients delivered at 5AM, You can put on a ghost costume and stage a paranormal event to scare the delivery crew away, leaving their shipment unsupervised, but only if you happen to pull off a really convincing performance", 0.2, Reward.random_from_tier(3), t1e1) #random tier 3 reward
static var t2e2 = Action.new("", "Stage paranormal sightings around the rival store's property. Doing this in front of teh security cameras may scare their employees from coming to work, but there's a chance they will figure out it's just you.", 0.7, Reward.random_from_tier(2), Action.REPEAT, t2e3) #random tier 2 reward
static var t2e1 = Action.new("", "Spread rumors of paranormal sightings at the rival store on social media.", 1.0, Reward.new([Reward.TYPES.POPULARITY], [0.5]), null, t2e2) #TODO how much pop
static var t2 = [t2e1, t2e2, t2e3]
#Tree 3: Rat?
static var t3e3 = Action.new("", "[name] somehow mastered puppeteering, allowing them to take control of a sleeping employee that it's been observing an have them acquire soem ingredients for you or sabotage the store a bit. With enough training, there's a chance you and [name] could pull this off.", 0.85, Reward.random_from_tier(3))
static var t3e2 = Action.new("", "Your rat, that you now named [name], has gotten better at infiltrating, so you cna try to take it to the next level and have them steal more or cause more pest-related damage to the store. It's not guaranteed, but might be worth a shot given [name]'s training.", 0.3, Reward.random_from_tier(2), REPEAT, t3e3) #TODO change rat's name
static var t3e1 = Action.new("", "You spot some rats by the dumpsters of the rival's store. You could train to to run in and swipe some ingredients from them or leave soem droppings to make them appear to have to have a pest problem.", 0.2, Reward.random_from_tier(1) ,REPEAT, t3e2)
static var t3 = [t3e1, t3e2, t3e3]

static var decision_trees = [t1,t2,t3]

# Actions that can be randomly selected

static var action_choices:Array[Action] = [
	STEAL_INGREDIENTS,
	BREAK_REGISTER,
	t1e1,
	t2e1,
	t3e1
	]

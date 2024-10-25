extends Resource

class_name Action

#action variables
var title: String
var desc: String
var chance: float
var reward: Rewards
enum Rewards {None, Money, Ingredients, DoorJam}

#Rewards Amount
#TODO reorganize later
const MONEY_RANGE = [10,100] #TODO what's a good money range?
const INGREDIENT_RANGE = [1,10] #TODO what's a good ingredient range?


func _init(arg1, p_desc:String = "", p_chance:float = 0.0, p_reward:Rewards= Rewards.None):
	if arg1 is Action:
		title = arg1.title
		desc = arg1.desc
		chance = arg1.chance
		reward = arg1.reward
	else:
		title = arg1
		desc = p_desc
		chance = clamp(p_chance, 0.0, 1.0)
		reward = p_reward
	

func apply_reward():
	#called when action roll passed. Apply multiply based on difficulty
	match reward:
		Rewards.None:
			pass
		Rewards.Money:
			#random number between money low and high * 1.0 + risk chance
			WRAPPER.money += (randi_range(MONEY_RANGE[0], MONEY_RANGE[1]))*(1.0+(1.0-chance))

static func random():
	return prefab_actions[randi()%prefab_actions.size()]

#Action Prefabs
static var STEAL_INGREDIENTS = Action.new("Steal ingredients", "The stock at your store is getting a little low, maybe the neighbor won't mind.", 0.5, Action.Rewards.Ingredients)
static var JAM_DOOR = Action.new("Jam rival's door", "Customers have reported that the neighbor's door is a little too easy to open...", 0.25, Action.Rewards.DoorJam)
static var BREAK_REGISTER = Action.new("Break register", "You attempt to break the register. Some money might fall out if you succeed.", 0.1, Action.Rewards.Money)
static var prefab_actions:Array[Action] = [
	STEAL_INGREDIENTS,
	JAM_DOOR,
	BREAK_REGISTER
	]

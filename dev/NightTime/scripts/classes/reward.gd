extends Resource

class_name Reward

var amount: Array[float] = [-1] #how much of each type
var type: Array = [TYPES.NONE] #what types

#Rewards Amount
#TODO reorganize later
const MONEY_RANGE = [10,100] #TODO what's a good money range?
const INGREDIENT_RANGE = [1,10] #TODO what's a good ingredient range?

enum TYPES{NONE, FLOUR, BUTTER, MILK, SUGAR, POPULARITY, MONEY}

func _init(arg1, p_amt:Array[float]=[-1]):
	if arg1 is Reward:
		amount = arg1.amount
		type = arg1.type
	else:	
		type = arg1
		amount = p_amt
	if amount.size() != type.size() and amount[0] != -1:
		printerr("Number of amounts don't match number of types for Reward", self, "(",amount,  " ", type,")")

func apply(chance:float):
	match self:
		Reward.NONE:
			pass
		Reward.RANDOM_MONEY:
			#random number between money low and high * 1.0 + risk chance
			WRAPPER.money += (randi_range(MONEY_RANGE[0], MONEY_RANGE[1]))*(1.0+(1.0-chance))
		Reward.RANDOM_INGREDIENT:
			WRAPPER.ingredients[randi() % WRAPPER.ingredients.size()].count += randi_range(INGREDIENT_RANGE[0], INGREDIENT_RANGE[1])*(1.0+(1.0-chance))
		_:
			for i in range(type.size()):
				match type[i]:
					TYPES.FLOUR:
						WRAPPER.ingredients[0].count += amount[i]
					TYPES.BUTTER:
						WRAPPER.ingredients[1].count += amount[i]
					TYPES.MILK:
						WRAPPER.ingredients[2].count += amount[i]
					TYPES.SUGAR:
						WRAPPER.ingredients[3].count += amount[i]
					TYPES.POPULARITY:
						WRAPPER.popularity += amount[i]
					TYPES.MONEY:
						WRAPPER.money += amount[i]

static var NONE = Reward.new([TYPES.NONE])
static var RANDOM_INGREDIENT = Reward.new([TYPES.FLOUR, TYPES.BUTTER, TYPES.MILK, TYPES.SUGAR])
static var RANDOM_POPULARITY = Reward.new([TYPES.POPULARITY])
static var RANDOM_MONEY = Reward.new([TYPES.MONEY])

static var TIERS = [
	[Reward.new([TYPES.POPULARITY], [0.1]), Reward.new([TYPES.MILK], [5]), Reward.new([TYPES.SUGAR], [5]), Reward.new([TYPES.MILK, TYPES.SUGAR], [2,2])],		#tier 1
	[Reward.new([TYPES.POPULARITY], [0.125]), Reward.new([TYPES.FLOUR, TYPES.BUTTER], [5,5]), Reward.new([TYPES.BUTTER], [10]), Reward.new([TYPES.FLOUR, TYPES.BUTTER, TYPES.MILK, TYPES.SUGAR], [1,1,1,1])],		#tier 2
	[Reward.new([TYPES.POPULARITY], [0.175]), Reward.new([TYPES.BUTTER, TYPES.SUGAR], [5,10]), Reward.new([TYPES.FLOUR, TYPES.BUTTER, TYPES.SUGAR], [10,10,5]), Reward.new([TYPES.FLOUR, TYPES.BUTTER, TYPES.MILK, TYPES.SUGAR], [2,2,2,2])],		#tier 3
	[Reward.new([TYPES.POPULARITY], [0.2]), Reward.new([TYPES.FLOUR, TYPES.BUTTER, TYPES.MILK, TYPES.SUGAR], [10,5,2,2]), Reward.new([TYPES.FLOUR, TYPES.BUTTER, TYPES.MILK, TYPES.SUGAR], [5,5,5,5]), Reward.new([TYPES.SUGAR], [15])]		#tier 4
]

static func random_from_tier(tier:int):
	return Reward.new(Reward.TIERS[tier-1][randi()%Reward.TIERS[tier].size()])

extends Object

class_name Action

#action variables
var title: String
var desc: String
var chance: float
var reward: Rewards
var risk: Risks
enum Rewards {None, Money}
enum Risks {None, Money, Police}

#Rewards Amount
#TODO reorganize later
const MONEY_RANGE = [10,100] #money ranges between 10 and 100

#Risks Amount
const POLICE_RANGE = [0.01,0.25] #police heat ranges from 1% to 25%


func _init(p_title:String, p_description:String, p_chance:float, p_reward:Rewards, p_risk:Risks):
	title = p_title
	desc = p_description
	chance = clamp(p_chance, 0.0, 1.0)
	reward = p_reward
	risk = p_risk
	
func apply_reward():
	#called when action roll passed. Apply multiply based on difficulty
	match reward:
		Rewards.None:
			pass
		Rewards.Money:
			#random number between money low and high * 1.0 + risk chance
			WRAPPER.money += (randi_range(MONEY_RANGE[0], MONEY_RANGE[1]))*(1.0+(1.0-chance))

func apply_risk():
	match risk:
		Risks.None:
			pass
		Risks.Police:
			WRAPPER.heat += (randf_range(POLICE_RANGE[0], POLICE_RANGE[1])*(1.0+(1.0-chance)))
		Risks.Money:
			WRAPPER.money -= (randi_range(MONEY_RANGE[0], MONEY_RANGE[1]))*(1.0+(1.0-chance))
		

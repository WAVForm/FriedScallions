extends Object

class_name Action

#action variables
var title: String
var desc: String
var chance: float
var reward: Rewards
var risk: Risks
enum Rewards {Money}
enum Risks {Police}

func _init(p_title:String, p_description:String, p_chance:float, p_reward:Rewards, p_risk:Risks):
	title = p_title
	desc = p_description
	chance = clamp(p_chance, 0.0, 1.0)
	reward = p_reward
	risk = p_risk

class_name Ingredient

var name: String
var count: int

func _init(ingredient_name: String, start_count: int) -> void:
	name = ingredient_name
	count = start_count

func can_consume(amount_to_consume: int = 1) -> bool:
	return count >= amount_to_consume

func consume(amount_to_consume: int = 1) -> bool:
	if can_consume(amount_to_consume):
		count -= amount_to_consume
		return true
	else:
		return false

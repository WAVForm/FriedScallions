class_name Purchaseable
var name: String

var count: int
var max_count: int = 3
var unlocked: int
var price: int

var base_cost: int
var mult_cost: int

signal spent(amount: int)

func _init(purchaseable_name: String, initial_cost: int, cost_per_count: int, initial_count: int = 1, current_unlock: int = 3) -> void:
	name = purchaseable_name
	base_cost = initial_cost
	mult_cost = cost_per_count
	count = initial_count
	unlocked = current_unlock
	recalculate_price()

func recalculate_price() -> void:
	price = base_cost + mult_cost * count

func attempt_purchase(money: int) -> bool:
	recalculate_price()
	if is_available() and money >= price:
		spent.emit(price)
		count += 1
		recalculate_price()
		return true
	else:
		return false

func is_available() -> bool:
	return (not is_at_max()) and is_unlocked()

func is_at_max() -> bool:
	return count >= max_count

func is_unlocked() -> bool:
	return count < unlocked

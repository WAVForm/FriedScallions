var name: String

var count: int = 1
var price: int = 10

signal spent(amount: int)

var base_cost: int
var mult_cost: int

func _init(purchaseable_name: String, initial_cost: int = 0, cost_per_count: int = 10) -> void:
	name = purchaseable_name
	base_cost = initial_cost
	mult_cost = cost_per_count
	recalculate_price()

func recalculate_price() -> void:
	price = base_cost + mult_cost * count

func attempt_purchase(money: int) -> bool:
	recalculate_price()
	if money >= price:
		spent.emit(price)
		count += 1
		recalculate_price()
		return true
	else:
		return false

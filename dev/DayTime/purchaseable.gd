var name: String = ""

var count: int = 1
var price: int = 10

signal spent(amount: int)

func recalculate_price() -> void:
	price = 10 * count

func attempt_purchase(money: int) -> bool:
	recalculate_price()
	if money >= price:
		spent.emit(price)
		count += 1
		recalculate_price()
		return true
	else:
		return false

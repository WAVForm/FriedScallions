extends Purchaseable
class_name RestockPurchaseable

var ingredient: Ingredient
var restock_count: int

func _init(purchaseable_name: String, cost: int, ingredient_to_restock: Ingredient, count_to_restock: int) -> void:
	ingredient = ingredient_to_restock
	restock_count = count_to_restock
	super(purchaseable_name, cost, 0, 0, 1)

func attempt_purchase(money: int) -> bool:
	recalculate_price()
	if is_available() and money >= price:
		spent.emit(price)
		ingredient.count += restock_count
		return true
	else:
		return false

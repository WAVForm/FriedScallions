class_name Product

var name: String
var sell_value: int
var popularity_value: int
var ingredients_list: Array
var ingredients_count: Array

func _init(product_name: String, recipe: Array, price: int, popularity: int) -> void:
	name = product_name
	sell_value = price
	popularity_value = popularity
	set_ingredients(recipe)

func set_ingredients(recipe: Array) -> void:
	ingredients_list = []
	ingredients_count = []
	for ingredient: Ingredient in recipe:
			if ingredient in ingredients_list:
				ingredients_count[ingredients_list.find(ingredient)] += 1
			else:
				ingredients_list.append(ingredient)
				ingredients_count.append(1)

func can_produce(count_to_produce: int = 1) -> bool:
	for i in range(len(ingredients_list)):
		if not ingredients_list[i].can_consume(count_to_produce * ingredients_count[i]):
			return false
	return true

func produce(count_to_produce: int = 1) -> bool:
	if can_produce(count_to_produce):
		for i in range(len(ingredients_list)):
			ingredients_list[i].consume(count_to_produce * ingredients_count[i])
		return true
	else:
		return false

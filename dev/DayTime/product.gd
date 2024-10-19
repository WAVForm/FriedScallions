extends StockItem
class_name Product

var recipe: Array

func _init(ingredients: Array) -> void:
	super("Custom Product")
	set_recipe(ingredients)

func set_recipe(ingredients: Array) -> void:
	recipe = []
	for ingredient: Ingredient in ingredients:
		var added = false
		for i in range(len(recipe)):
			if ingredient.id <= recipe[i].id:
				recipe.insert(i, ingredient)
				added = true
				break
		if not added:
			recipe.append(ingredient)
	generate_id()
	calculate_value()

func generate_id() -> String:
	id = ""
	for ingredient: Ingredient in recipe:
		id += ingredient.id
	match id:
		"011":
			name = "Item Combo 1"
		"022":
			name = "Item Combo 2"
		"012":
			name = "Item Combo 3"
		_:
			name = "Custom_Product_" + id
	return id

func calculate_value() -> int:
	value = 2
	for ingredient: Ingredient in recipe:
		value += ingredient.value
	return value

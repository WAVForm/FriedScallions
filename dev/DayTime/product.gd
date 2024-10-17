extends StockItem
class_name Product

var recipe: Array

func _init(ingredients: Array) -> void:
	super("Custom Product")
	set_recipe(ingredients)
	generate_id()

func set_recipe(ingredients: Array) -> void:
	recipe = []
	for ingredient: Ingredient in ingredients:
		# TODO Sort this
		recipe.append(ingredient)

func generate_id() -> String:
	id = ""
	for ingredient: Ingredient in recipe:
		id += ingredient.id
	id = "0000"
	match id:
		"0000":
			name = "Debug Product"
	return id

extends Panel

@onready var label = $Label

var recipe: Array
var ingredients: Array

signal finish_product(made_product: Product)

func _process(delta: float) -> void:
	label.text = ""
	for ingredient: Ingredient in recipe:
		label.text += ingredient.name + " "

func start_making_product(current_ingredients: Array) -> void:
	recipe = []
	ingredients = current_ingredients

func _use_ingredient(ingredient_num: int) -> void:
	if ingredients[ingredient_num].remove_count(1):
		recipe.append(ingredients[ingredient_num])


func _on_ingredient_0_pressed() -> void:
	_use_ingredient(0)

func _on_ingredient_1_pressed() -> void:
	_use_ingredient(1)

func _on_ingredient_2_pressed() -> void:
	_use_ingredient(2)

func _on_ingredient_3_pressed() -> void:
	_use_ingredient(3)


func _on_done_pressed() -> void:
	finish_product.emit(Product.new(recipe))

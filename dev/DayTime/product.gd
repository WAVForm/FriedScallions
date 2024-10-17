extends StockItem
class_name Product

var recipe: Array

func _init(product_name: String) -> void:
	super(product_name)

func set_recipe(ingredients: Array) -> void:
	recipe = []
	for ingredient in ingredients:
		var new_ingredient: bool = true
		for consume_item_event: ConsumeItemEvent in recipe:
			if consume_item_event.stock_item == ingredient:
				consume_item_event.count += 1
				new_ingredient = false
				break
		if new_ingredient:
			recipe.append(ConsumeItemEvent.new(ingredient))

func can_produce() -> bool:
	for consume_item_event: ConsumeItemEvent in recipe:
		if not consume_item_event.can_consume():
			return false
	return true

extends StockItem
class_name Ingredient

func _init(ingredient_name: String, id_num_as_str: String, sell_value: int = 1) -> void:
	super(ingredient_name)
	id = id_num_as_str
	value = sell_value

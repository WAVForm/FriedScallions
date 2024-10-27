class_name Customer
var order: Array
var patience: float = 30.0
var max_patience: float = 30.0
var position: float = 200.0

var patience_percentage: float:
	get: 
		return patience / max_patience

func _init(order_products: Array) -> void:
	order = order_products

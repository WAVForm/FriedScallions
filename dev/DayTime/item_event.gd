class_name ItemEvent

# Event types
const ORDER: int = 0
const CONSUME: int = 1
const RESTOCK: int = 2

var stock_item: StockItem
var count: int
var event_type: int # See above constants for event types

func _init(item: StockItem, amount: int, type: int) -> void:
	stock_item = item
	count = amount
	event_type = type

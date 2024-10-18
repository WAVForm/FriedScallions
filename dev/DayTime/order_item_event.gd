extends ItemEvent
class_name OrderItemEvent

func _init(item: StockItem, amount: int = 1) -> void:
	super(item, amount, ItemEvent.ORDER)

func can_serve() -> bool:
	return stock_item.can_remove_count(1)

func serve() -> bool:
	return stock_item.remove_count(1)

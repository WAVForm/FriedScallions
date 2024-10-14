extends ItemEvent
class_name ConsumeItemEvent

func _init(item: StockItem, amount: int = 1) -> void:
	super(item, amount, ItemEvent.CONSUME)

func can_consume() -> bool:
	return stock_item.count >= count

func consume() -> bool:
	return stock_item.remove_count(count)

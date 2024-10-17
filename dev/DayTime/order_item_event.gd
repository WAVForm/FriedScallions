extends ItemEvent
class_name OrderItemEvent

func _init(item: StockItem, amount: int = 1) -> void:
	super(item, amount, ItemEvent.ORDER)

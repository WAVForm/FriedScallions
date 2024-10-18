extends ItemEvent
class_name RestockItemEvent

var time_remaining: float

func _init(item: StockItem, amount: int = 1, delay_time: float = 5.0) -> void:
	super(item, amount, ItemEvent.RESTOCK)
	time_remaining = delay_time

func restock() -> void:
	stock_item.add_count(count)

func tick_time(delta: float) -> bool:
	time_remaining -= delta
	return time_remaining <= 0

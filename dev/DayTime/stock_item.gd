class_name StockItem
var name: String

var count: int = 1

func _init(item_name: String) -> void:
	name = item_name

func can_remove_count(count_to_remove: int) -> bool:
	return count >= count_to_remove

func remove_count(count_to_remove: int) -> bool:
	if count >= count_to_remove:
		count -= count_to_remove
		return true
	else:
		return false

func add_count(count_to_add: int) -> void:
	count += count_to_add

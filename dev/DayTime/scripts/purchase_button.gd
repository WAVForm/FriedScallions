extends AspectRatioContainer

var purchaseable: Purchaseable = null

@onready var label = $AspectRatioContainer/VBoxContainer/Label
@onready var button = $AspectRatioContainer/VBoxContainer/Button

signal purchaseable_pressed(purchaseable_to_buy)

func _ready() -> void:
	update_display()

func set_purchaseable(purchaseable_to_set) -> void:
	purchaseable = purchaseable_to_set

func update_display() -> void:
	if purchaseable != null:
		if purchaseable is RestockPurchaseable:
			label.text = purchaseable.name + " (+" + str(purchaseable.restock_count) + ")"
		else:
			label.text = purchaseable.name + " - Lvl " + str(purchaseable.count)
		if purchaseable.is_at_max():
			button.text = "Max"
			button.disabled = true
		elif purchaseable.is_unlocked():
			if purchaseable.count == 0:
				button.text = "Buy ($" + str(purchaseable.price) + ")"
			else:
				button.text = "Upgrade ($" + str(purchaseable.price) + ")"
			button.disabled = false
		else:
			self.visible = false
			button.text = "Locked"
			button.disabled = true

func _on_button_pressed() -> void:
	purchaseable_pressed.emit(purchaseable)
	update_display()

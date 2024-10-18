extends PanelContainer

var purchaseable = null

@onready var label = $VBoxContainer/Label
@onready var button = $VBoxContainer/Button

signal purchaseable_pressed(purchaseable_to_buy)

func set_purchaseable(purchaseable_to_set) -> void:
	purchaseable = purchaseable_to_set
	update_display()

func update_display() -> void:
	if purchaseable != null:
		label.text = purchaseable.name + " - Lvl " + str(purchaseable.count)
		button.text = "Buy ($" + str(purchaseable.price) + ")"

func _on_button_pressed() -> void:
	purchaseable_pressed.emit(purchaseable)
	update_display()

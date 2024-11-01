extends Node2D
class_name DayMain

const purchaseable_button_scene = preload("res://dev/DayTime/scenes/purchase_button.tscn")
const number_popup_scene = preload("res://dev/DayTime/scenes/number_popup.tscn")

static var money: int = 100
static var popularity: int = 0
static var ingredient_dict: Dictionary = {}
static var ingredients: Array[Ingredient] = [
	create_ingredient("Flour", 50, "F"),
	create_ingredient("Butter", 50, "B"),
	create_ingredient("Milk", 50, "M"),
	create_ingredient("Sugar", 50, "S")
]
static var restock_purchaseables: Array[RestockPurchaseable] = [
	RestockPurchaseable.new("Flour", 5, ingredient_dict.F, 15),
	RestockPurchaseable.new("Butter", 5, ingredient_dict.B, 15),
	RestockPurchaseable.new("Milk", 5, ingredient_dict.M, 15),
	RestockPurchaseable.new("Sugar", 5, ingredient_dict.S, 15)
]
static var purchaseables: Array[Purchaseable] = [
	Purchaseable.new("Pastry", 5, 5, 0, 0),
	Purchaseable.new("Coffee", 5, 5, 1, 1),
	Purchaseable.new("Tea", 5, 5, 1, 1),
	Purchaseable.new("Cake", 5, 5, 0, 0),
	Purchaseable.new("Server", 5, 5, 0, 0)
]
static var pastries: Array[Product] = [
	create_product("Croissant", ["F", "B"], 1, 1),
	create_product("Butter Croissant", ["F", "B", "B"], 2, 2),
	create_product("Sugar Croissant", ["F", "B", "S"], 5, 3)
]
static var coffees: Array[Product] = [
	create_product("Americano", ["M", "S"], 1, 2),
	create_product("Caramel Frappe", ["M", "S", "S"], 2, 3),
	create_product("crack", ["M", "M", "S", "S"], 4, 25)
]
static var teas: Array[Product] = [
	create_product("Black Tea", ["S"], 1, 1),
	create_product("Earl Grey", ["S", "S"], 1, 3),
	create_product("Chai Latte", ["M", "S", "S"], 3, 4)
]
static var cakes: Array[Product] = [
	create_product("Vanilla Cake", ["F", "B", "M", "S"], 4, 3),
	create_product("2-Layer Cake", ["F", "B", "M", "S", "S"], 6, 5),
	create_product("Birthday Cake", ["F", "B", "B", "M", "S", "S"], 9, 9)
]
static var null_product: Product = Product.new("null", [], 0, 0)

# TODO FIX THIS CLEAN IT UP
@onready var morning_ui = $MorningUI
@onready var shop_menu = $MorningUI/ShopMenu
@onready var restock_bar = $MorningUI/ShopMenu/Row/Column1
@onready var upgrade_bar = $MorningUI/ShopMenu/Row/Column2
@onready var employee_bar = $MorningUI/ShopMenu/Row/Column3
@onready var money_display = $MorningUI/Money
@onready var morning_ingredient_label = $MorningUI/IngredientLabel

# TODO UBER JANK DEV UI REALLY REALLY FIX'
@onready var day_ui = $GameUI
@onready var progress_bar = $GameUI/ProgressBar
@onready var day_ingredient_label = $GameUI/IngredientLabel
@onready var product_label = $GameUI/ProductLabel
@onready var customer_label = $GameUI/CustomerLabel
@onready var auto_serve_display = $GameUI/AutoServeDisplay
@onready var auto_serve_progress_bar = $GameUI/AutoServeDisplay/AutoServe
@onready var day_cycle_progress_bar = $GameUI/DayProgressBar
@onready var make_pastry_button = $GameUI/Pastry
@onready var make_coffee_button = $GameUI/Coffee
@onready var make_tea_button = $GameUI/Tea
@onready var make_cake_button = $GameUI/Cake
@onready var serve_button = $GameUI/ServeButton
@onready var trash_button = $GameUI/Trash


static var server: bool:
	get:
		return purchaseables[4].count >= 1

var progress: float = 0.0
var customers: Array[Customer] = []

var customer_timer: float = 0.0

var auto_serve_progress: float = 0.0

var day_cycle_progress: float = 0.0
var day_cycle_length: int = 60

var pastry: Product
var coffee: Product
var tea: Product
var cake: Product
var counter: Array[Product] = []

var time_scale: float = 1.0
enum STATES {NONE, PASTRY, COFFEE, TEA, CAKE, MANUAL_SERVING}
var state: STATES = STATES.NONE
var day_started: bool = false
var day_ended: bool = false

static func create_ingredient(ingredient_name: String, start_count: int, initial: String) -> Ingredient:
	var new_ingredient = Ingredient.new(ingredient_name, start_count)
	ingredient_dict[initial] = new_ingredient
	return new_ingredient

static func create_product(p_product_name: String, p_initials_recipe: Array[String], p_price: int, p_popularity: int) -> Product:
	return Product.new(p_product_name, generate_recipe(p_initials_recipe), p_price, p_popularity)

static func generate_recipe(initials_recipe: Array[String]) -> Array[Ingredient]:
	var recipe: Array[Ingredient] = []
	for initial in initials_recipe:
		recipe.append(ingredient_dict[initial])
	return recipe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restock_bar.add_child(_create_purchaseable_button(restock_purchaseables[0]))
	restock_bar.add_child(_create_purchaseable_button(restock_purchaseables[1]))
	restock_bar.add_child(_create_purchaseable_button(restock_purchaseables[2]))
	restock_bar.add_child(_create_purchaseable_button(restock_purchaseables[3]))
	
	upgrade_bar.add_child(_create_purchaseable_button(purchaseables[0]))
	upgrade_bar.add_child(_create_purchaseable_button(purchaseables[1]))
	upgrade_bar.add_child(_create_purchaseable_button(purchaseables[2]))
	upgrade_bar.add_child(_create_purchaseable_button(purchaseables[3]))
	
	employee_bar.add_child(_create_purchaseable_button(purchaseables[4]))
	
	if server:
		spend_money(5 * purchaseables[4].count)
	
	update_current_products()
	update_money_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if day_started:
		_day_cycle_process(time_scale * delta)
		_server_process(time_scale * delta)
		_manual_state_process(time_scale * delta)
		_customer_process(time_scale * delta)
	_update_labels()
	if state != STATES.NONE and not counter_full():
		make_pastry_button.disabled = true
		make_coffee_button.disabled = true
		make_tea_button.disabled = true
		make_cake_button.disabled = true
	else:
		make_pastry_button.disabled = counter_full() or not pastry.can_produce()
		make_coffee_button.disabled = counter_full() or not coffee.can_produce()
		make_tea_button.disabled = counter_full() or not tea.can_produce()
		make_cake_button.disabled = counter_full() or not cake.can_produce()
	serve_button.disabled = not (state == STATES.NONE and can_serve_customer())
	trash_button.disabled = len(counter) == 0

func _draw() -> void:
	# TODO FIX FIX FIX SUPER DUPER DUPER TEMP
	for customer in customers:
		var percentage = customer.patience_percentage
		var customer_color
		if percentage > 0.5:
			customer_color = Color(2.0 * (1.0 - percentage), 1.0, 0.0)
		else:
			customer_color = Color(1.0, 2.0 * (percentage), 0.0)
		draw_circle(Vector2(300, 350 - customer.position), 10.0, customer_color)

func _day_cycle_process(delta) -> void:
	day_cycle_progress += delta
	day_cycle_progress_bar.value = day_cycle_progress
	day_cycle_progress_bar.max_value = day_cycle_length
	if day_cycle_progress > day_cycle_length:
		day_ended = true
		if len(customers) == 0:
			print("Money: $" + str(money))
			WRAPPER.change_scene(WRAPPER.SCENES.DUSK) # TODO bring up day summary when day is done. Go to dusk once user dismisses

func _server_process(delta) -> void:
	if server:
		if can_serve_customer():
			auto_serve_progress += delta
			var duration = 2.0 / (0.5 + 0.5 * purchaseables[4].count)
			if auto_serve_progress >= duration:
				auto_serve_progress = 0.0
				_serve_customer()
			auto_serve_progress_bar.value = auto_serve_progress / duration
		else:
			auto_serve_progress = 0.0
			auto_serve_progress_bar.value = 0.0

func _manual_state_process(delta) -> void:
	match state:
		STATES.PASTRY:
			var duration = 1.0
			progress += delta
			if progress >= duration:
				pastry.produce()
				counter.append(pastry)
				_clear_state()
			progress_bar.value = progress / duration
		STATES.COFFEE:
			var duration = 1.0
			progress += delta
			if progress >= duration:
				coffee.produce()
				counter.append(coffee)
				_clear_state()
			progress_bar.value = progress / duration
		STATES.TEA:
			var duration = 1.0
			progress += delta
			if progress >= duration:
				tea.produce()
				counter.append(tea)
				_clear_state()
			progress_bar.value = progress / duration
		STATES.CAKE:
			var duration = 1.0
			progress += delta
			if progress >= duration:
				cake.produce()
				counter.append(cake)
				_clear_state()
			progress_bar.value = progress / duration
		STATES.MANUAL_SERVING: 
			var duration = 1.0
			progress += delta
			if progress >= duration:
				_serve_customer()
				_clear_state()
			progress_bar.value = progress / duration

func _customer_process(delta) -> void:
	var customer_rate = 6.0
	if not day_ended:
		customer_timer += delta
	if customer_timer >= customer_rate:
		customer_timer -= customer_rate 
		var order = []
		for i in range(randi_range(1, 3)):
			var new_order_product = null_product
			while new_order_product == null_product:
				match randi_range(1, 4):
					1:
						new_order_product = pastry
					2:
						new_order_product = coffee
					3:
						new_order_product = tea
					4:
						new_order_product = cake
			order.append(new_order_product)
		customers.append(Customer.new(order))
	for i in range(len(customers)):
		customers[i].position = clamp(customers[i].position - 50.0 * delta, 30.0 * i, 200.0)
		if customers[i].position == 0:
			if state != STATES.MANUAL_SERVING:
				customers[i].patience -= 2.0 * delta
		else:
			customers[i].patience -= 1.0 * delta
		queue_redraw()
	if len(customers) > 0:
		if len(customers[0].order) == 0:
			customers.pop_front()
		elif customers[0].patience < 0.0:
			customers.pop_front()
	var current_order = ""
	var patience = ""
	if len(customers) > 0:
		if customers[0].position == 0.0:
			for item: Product in customers[0].order:
				current_order += item.name + " "
			patience = str(floor(customers[0].patience))
	customer_label.text = "Current Order: " + current_order + "\nPatience: " + patience + "\nCustomers in line: " + str(len(customers))

func _update_labels() -> void:
	var ingredient_label_text = "Ingredients:"
	for ingredient: Ingredient in ingredients:
		ingredient_label_text += "\n" + ingredient.name + ": " + str(ingredient.count)
	morning_ingredient_label.text = ingredient_label_text
	day_ingredient_label.text = ingredient_label_text
	product_label.text = "Products (max: 4):"
	for product: Product in counter:
		product_label.text += "\n" + product.name

func update_current_products() -> void:
	if purchaseables[0].count > 0:
		pastry = pastries[purchaseables[0].count - 1]
	else:
		pastry = null_product
	if purchaseables[1].count > 0:
		coffee = coffees[purchaseables[1].count - 1]
	else:
		coffee = null_product
	if purchaseables[2].count > 0:
		tea = teas[purchaseables[2].count - 1]
	else:
		tea = null_product
	if purchaseables[3].count > 0:
		cake = cakes[purchaseables[3].count - 1]
	else:
		cake = null_product

func _attempt_enter_state(new_state: STATES) -> bool:
	if state == STATES.NONE:
		state = new_state
		return true
	return false

func _clear_state() -> void:
	state = STATES.NONE
	progress = 0.0

func update_money_display() -> void:
	money_display.text = "Money: $" + str(money)

func earn_money(amount) -> void:
	money += amount
	update_money_display()

func spend_money(amount) -> void:
	money -= amount
	update_money_display()

func attempt_purchase(purchaseable) -> void:
	purchaseable.attempt_purchase(money)


func _create_purchaseable_button(purchaseable: Purchaseable) -> Node:
	purchaseable.spent.connect(spend_money)
	var new_purchaseable_button = purchaseable_button_scene.instantiate()
	new_purchaseable_button.set_purchaseable(purchaseable)
	new_purchaseable_button.purchaseable_pressed.connect(attempt_purchase)
	return new_purchaseable_button

func _start_serving_customer() -> void:
	if state == STATES.NONE and can_serve_customer():
		state = STATES.MANUAL_SERVING

func _serve_customer() -> bool:
	for i in range(len(customers[0].order)):
		if customers[0].order[i] in counter:
			var money_gain = customers[0].order[i].sell_value + int(floor(customers[0].patience / 10.0))
			var popularity_gain = customers[0].order[i].popularity_value + int(floor(customers[0].patience / 10.0))
			earn_money(money_gain)
			popularity += popularity_gain
			var money_popup = number_popup_scene.instantiate()
			money_popup.text = "+" + str(money_gain) + " Money"
			money_popup.position.x += 500
			money_popup.position.y += 500
			day_ui.add_child(money_popup)
			var popularity_popup = number_popup_scene.instantiate()
			popularity_popup.text = "+" + str(popularity_gain) + " Popularity"
			popularity_popup.position.x += 500
			popularity_popup.position.y += 500
			popularity_popup.delay = 0.375
			day_ui.add_child(popularity_popup)
			counter.erase(customers[0].order[i])
			customers[0].order.remove_at(i)
			return true
	return false

func can_serve_customer() -> bool:
	if len(customers) > 0:
		if customers[0].position == 0.0:
			for item: Product in customers[0].order:
				if item in counter:
						return true
	return false

func counter_full() -> bool:
	return len(counter) >= 4

func _on_quit_pressed() -> void:
	WRAPPER.change_scene(WRAPPER.SCENES.DEBUG) #TODO gotta make a real pause menu


func _on_start_day_pressed() -> void:
	day_started = true
	morning_ui.visible = false
	day_ui.visible = true
	update_current_products()
	make_pastry_button.visible = pastry != null_product
	make_coffee_button.visible = coffee != null_product
	make_tea_button.visible = tea != null_product
	make_cake_button.visible = cake != null_product
	auto_serve_display.visible = server

func _on_trash_pressed() -> void:
	counter.pop_front()


func _on_pastry_pressed() -> void:
	if pastry.can_produce() and not counter_full():
		_attempt_enter_state(STATES.PASTRY)

func _on_coffee_pressed() -> void:
	if coffee.can_produce() and not counter_full():
		_attempt_enter_state(STATES.COFFEE)

func _on_tea_pressed() -> void:
	if tea.can_produce() and not counter_full():
		_attempt_enter_state(STATES.TEA)

func _on_cake_pressed() -> void:
	if cake.can_produce() and not counter_full():
		_attempt_enter_state(STATES.CAKE)
extends Node2D

const purchaseable_button_scene = preload("res://dev/DayTime/purchase_button.tscn")

# TODO FIX THIS CLEAN IT UP
@onready var shop_menu = $PopupUI/ShopMenu
@onready var restock_bar = $PopupUI/ShopMenu/Row/Column1
@onready var upgrade_bar = $PopupUI/ShopMenu/Row/Column2
@onready var product_menu = $PopupUI/MakeProductMenu
@onready var money_display = $GameUI/Money

# TODO UBER JANK DEV UI REALLY REALLY FIX
@onready var progress_bar = $GameWorld/ProgressBar
@onready var ingredient_label = $GameWorld/IngredientLabel
@onready var product_label = $GameWorld/ProductLabel
@onready var customer_label = $GameWorld/CustomerLabel
@onready var hire_button = $GameWorld/Hire
@onready var auto_serve_display = $GameWorld/AutoServeDisplay
@onready var auto_serve_progress_bar = $GameWorld/AutoServeDisplay/AutoServe
@onready var day_cycle_progress_bar = $GameWorld/ProgressBar2

var item1_upgrade
var item2_upgrade
var server_upgrade
var advertisement_upgrade

var server: bool = false

var progress: float = 0.0
var customers: Array = []

var customer_timer: float = 5.0

var auto_serve_progress: float = 0.0
var server_payment_progress: float = 0.0

var day_cycle_progress: float = 0.0
var day_cycle_length: int = 60


var money: int = 100
var ingredients: Array = []
var products: Array = []
var purchaseables: Array = []

var time_scale: float = 1.0
enum STATES {NONE, SHOPPING, MAKING_PRODUCT, MANUAL_SERVING}
var state: STATES = STATES.NONE
var day_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ingredients.append(Ingredient.new("Cup", "0"))
	ingredients.append(Ingredient.new("BeanA", "1"))
	ingredients.append(Ingredient.new("BeanB", "2"))
	ingredients.append(Ingredient.new("Sugar", "3"))
	for ingredient: Ingredient in ingredients:
		ingredient.add_count(49)
	
	item1_upgrade = _create_purchaseable("Don't Buy", 2500, 25)
	upgrade_bar.add_child(_create_purchaseable_button(item1_upgrade))
	item2_upgrade = _create_purchaseable("Don't Buy", 2500, 25)
	upgrade_bar.add_child(_create_purchaseable_button(item2_upgrade))
	server_upgrade = _create_purchaseable("Serving", 0, 20)
	upgrade_bar.add_child(_create_purchaseable_button(server_upgrade))
	advertisement_upgrade = _create_purchaseable("Post Ad", 10)
	upgrade_bar.add_child(_create_purchaseable_button(advertisement_upgrade))
	
	update_money_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		STATES.SHOPPING:
			time_scale = 0.5
		STATES.MAKING_PRODUCT:
			time_scale = 0.5
		_:
			time_scale = 1.0
	if day_started:
		_day_cycle_process(time_scale * delta)
		_server_process(time_scale * delta)
		_manual_serve_process(time_scale * delta)
		_customer_process(time_scale * delta)
	_update_labels()

func _draw() -> void:
	# TODO FIX FIX FIX SUPER DUPER DUPER TEMP
	for customer in customers:
		var percentage = customer.patience_percentage
		var customer_color
		if percentage > 0.5:
			customer_color = Color(2.0 * (1.0 - percentage), 1.0, 0.0)
		else:
			customer_color = Color(1.0, 2.0 * (percentage), 0.0)
		draw_circle(Vector2(300, 450 + customer.position), 10.0, customer_color)

func _day_cycle_process(delta) -> void:
	day_cycle_progress += delta
	day_cycle_progress_bar.value = day_cycle_progress
	day_cycle_progress_bar.max_value = day_cycle_length
	if day_cycle_progress > day_cycle_length:
		WRAPPER.change_scene(WRAPPER.SCENES.DUSK) # TODO bring up day summary when day is done. Go to dusk once user dismisses

func _server_process(delta) -> void:
	if server:
		if _customer_servable():
			auto_serve_progress += delta
			var duration = 10.0 / (5.0 + server_upgrade.count)
			if auto_serve_progress >= duration:
				auto_serve_progress = 0.0
				_serve_customer()
			auto_serve_progress_bar.value = auto_serve_progress / duration
		else:
			auto_serve_progress = 0.0
			auto_serve_progress_bar.value = 0.0
		server_payment_progress += delta
		if server_payment_progress >= 1.0:
			server_payment_progress -= 1.0
			if money >= 1:
				spend_money(1)
			else:
				_server_quit()

func _manual_serve_process(delta) -> void:
	if state == STATES.MANUAL_SERVING:
		var duration = 5.0 / (5.0 + server_upgrade.count)
		progress += delta
		if progress >= duration:
			_serve_customer()
			_clear_state()
		progress_bar.value = progress / duration

func _customer_process(delta) -> void:
	customer_timer -= delta
	if customer_timer <= 0.0:
		customer_timer += 7.0 / (1.0 + 0.1 * advertisement_upgrade.count)
		var order = []
		for i in range(randi_range(1, 2)):
			var product = null
			match randi_range(1, 3):
				1:
					product = Product.new([ingredients[0], ingredients[1], ingredients[1]])
				2:
					product = Product.new([ingredients[0], ingredients[2], ingredients[2]])
				3:
					product = Product.new([ingredients[0], ingredients[1], ingredients[2]])
			order.append(product)
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
			for item: StockItem in customers[0].order:
				current_order += item.name + " "
			patience = str(floor(customers[0].patience))
	customer_label.text = "Current Order: " + current_order + "\nPatience: " + patience + "\nCustomers in line: " + str(len(customers))

func _update_labels() -> void:
	ingredient_label.text = "Ingredients:"
	for ingredient: Ingredient in ingredients:
		ingredient_label.text += "\n" + ingredient.name + ": " + str(ingredient.count)
	product_label.text = "Products (max: 4):"
	for product: Product in products:
		product_label.text += "\n" + product.name

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

func _create_purchaseable(purchaseable_name: String = "", initial_cost: int = 0, cost_per_count: int = 10) -> Purchaseable:
	var new_purchaseable = Purchaseable.new(purchaseable_name, initial_cost, cost_per_count)
	new_purchaseable.spent.connect(spend_money)
	purchaseables.append(new_purchaseable)
	return new_purchaseable

func _create_purchaseable_button(purchaseable: Purchaseable) -> Node:
	var new_purchaseable_button = purchaseable_button_scene.instantiate()
	new_purchaseable_button.set_purchaseable(purchaseable)
	new_purchaseable_button.purchaseable_pressed.connect(attempt_purchase)
	return new_purchaseable_button

func _open_shop() -> void:
	if state == STATES.NONE:
		state = STATES.SHOPPING
		shop_menu.visible = true

func _close_shop() -> void:
	if state == STATES.SHOPPING:
		state = STATES.NONE
		shop_menu.visible = false

func _start_making_product() -> void:
	if state == STATES.NONE and len(products) < 4:
		state = STATES.MAKING_PRODUCT
		product_menu.visible = true
		product_menu.start_making_product(ingredients)

func _finish_product(made_product: Product) -> void:
	if len(made_product.recipe) > 1:
		products.append(made_product)
	state = STATES.NONE
	product_menu.visible = false

func _start_serving_customer() -> void:
	if state == STATES.NONE and _customer_servable():
		state = STATES.MANUAL_SERVING

func _serve_customer() -> bool:
	for i in range(len(customers[0].order)):
		for j in range(len(products)):
			if customers[0].order[i].is_identical(products[j]):
				earn_money(customers[0].order[i].value + int(floor(customers[0].patience / 10.0)))
				customers[0].order.remove_at(i)
				products.remove_at(j)
				return true
	return false

func _customer_servable() -> bool:
	if len(customers) > 0:
		if customers[0].position == 0.0:
			for item: StockItem in customers[0].order:
				for product: Product in products:
					if item.is_identical(product):
						return true
	return false

func _server_quit() -> void:
	server = false
	hire_button.visible = true
	auto_serve_display.visible = false

func _hire_server() -> void:
	if money > 50:
		spend_money(50)
		server = true
		hire_button.visible = false
		auto_serve_display.visible = true

func _on_quit_pressed() -> void:
	WRAPPER.change_scene(WRAPPER.SCENES.DEBUG) #TODO gotta make a real pause menu

func _toggle_shop_menu() -> void:
	if state == STATES.NONE:
		_open_shop()
	else:
		_close_shop()


func _on_start_day_pressed() -> void:
	day_started = true
	$GameWorld/StartDay.visible = false


func _on_trash_pressed() -> void:
	products.pop_front()

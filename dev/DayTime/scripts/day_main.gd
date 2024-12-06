extends Node2D
class_name DayMain

const purchaseable_button_scene = preload("res://dev/DayTime/scenes/purchase_button.tscn")
const number_popup_scene = preload("res://dev/DayTime/scenes/number_popup.tscn")
const stat_display_scene = preload("res://dev/DayTime/scenes/statistic_display.tscn")

@export_category("General")
@export var DAY_LENGTH: float = 60.0
@export var STARTING_MONEY: int = 100
@export var STARTING_POPULARITY: int = 10
@export var PRODUCTION_TIME: float = 1.0
@export var SERVING_TIME: float = 1.0
@export_subgroup("Enemy")
@export var ENEMY_STARTING_POPULARITY: int = 0
@export var ENEMY_POPULARITY_GROWTH: int = 20
@export_subgroup("Customer")
@export var INITIAL_PATIENCE: float = 30.0
##Amount of patience restored upon being served (partial order)
@export var PATIENCE_ON_SERVE: int = 5
##Decay of patience/second
@export var PATIENCE_DECAY: float = 2.0
##Multiplier to slow the decay of patience if they "haven't ordered yet"
@export var IN_LINE_MULT: float = 0.325

@export_category("Pastry")
@export_subgroup("1")
@export var PASTRY_1_NAME: String = "Pastry1"
@export var PASTRY_1_TEXTURE: Texture2D
@export var PASTRY_1_RECIPE: Array[String] = ["F", "B"]
@export var PASTRY_1_PRICE: int = 1
@export var PASTRY_1_POPULARITY: int = 1
@export_subgroup("2")
@export var PASTRY_2_NAME: String = "Pastry2"
@export var PASTRY_2_TEXTURE: Texture2D
@export var PASTRY_2_RECIPE: Array[String] = ["F", "B"]
@export var PASTRY_2_PRICE: int = 1
@export var PASTRY_2_POPULARITY: int = 1
@export_subgroup("3")
@export var PASTRY_3_NAME: String = "Pastry3"
@export var PASTRY_3_TEXTURE: Texture2D
@export var PASTRY_3_RECIPE: Array[String] = ["F", "B"]
@export var PASTRY_3_PRICE: int = 1
@export var PASTRY_3_POPULARITY: int = 1
@export_subgroup("Upgrade")
@export var PASTRY_PRICE_BASE: int = 5
@export var PASTRY_PRICE_SCALE: int = 5
@export var PASTRY_INITIAL_LEVEL: int = 0
@export var PASTRY_INITIAL_UNLOCK: int = 0

@export_category("Coffee")
@export_subgroup("1")
@export var COFFEE_1_NAME: String = "Coffee1"
@export var COFFEE_1_TEXTURE: Texture2D
@export var COFFEE_1_RECIPE: Array[String] = ["F", "B"]
@export var COFFEE_1_PRICE: int = 1
@export var COFFEE_1_POPULARITY: int = 1
@export_subgroup("2")
@export var COFFEE_2_NAME: String = "Coffee2"
@export var COFFEE_2_TEXTURE: Texture2D
@export var COFFEE_2_RECIPE: Array[String] = ["F", "B"]
@export var COFFEE_2_PRICE: int = 1
@export var COFFEE_2_POPULARITY: int = 1
@export_subgroup("3")
@export var COFFEE_3_NAME: String = "Coffee3"
@export var COFFEE_3_TEXTURE: Texture2D
@export var COFFEE_3_RECIPE: Array[String] = ["F", "B"]
@export var COFFEE_3_PRICE: int = 1
@export var COFFEE_3_POPULARITY: int = 1
@export_subgroup("Upgrade")
@export var COFFEE_PRICE_BASE: int = 5
@export var COFFEE_PRICE_SCALE: int = 5
@export var COFFEE_INITIAL_LEVEL: int = 1
@export var COFFEE_INITIAL_UNLOCK: int = 1

@export_category("Tea")
@export_subgroup("1")
@export var TEA_1_NAME: String = "Tea1"
@export var TEA_1_TEXTURE: Texture2D
@export var TEA_1_RECIPE: Array[String] = ["F", "B"]
@export var TEA_1_PRICE: int = 1
@export var TEA_1_POPULARITY: int = 1
@export_subgroup("2")
@export var TEA_2_NAME: String = "Tea2"
@export var TEA_2_TEXTURE: Texture2D
@export var TEA_2_RECIPE: Array[String] = ["F", "B"]
@export var TEA_2_PRICE: int = 1
@export var TEA_2_POPULARITY: int = 1
@export_subgroup("3")
@export var TEA_3_NAME: String = "Tea3"
@export var TEA_3_TEXTURE: Texture2D
@export var TEA_3_RECIPE: Array[String] = ["F", "B"]
@export var TEA_3_PRICE: int = 1
@export var TEA_3_POPULARITY: int = 1
@export_subgroup("Upgrade")
@export var TEA_PRICE_BASE: int = 5
@export var TEA_PRICE_SCALE: int = 5
@export var TEA_INITIAL_LEVEL: int = 1
@export var TEA_INITIAL_UNLOCK: int = 1

@export_category("Cake")
@export_subgroup("1")
@export var CAKE_1_NAME: String = "Cake1"
@export var CAKE_1_TEXTURE: Texture2D
@export var CAKE_1_RECIPE: Array[String] = ["F", "B"]
@export var CAKE_1_PRICE: int = 1
@export var CAKE_1_POPULARITY: int = 1
@export_subgroup("2")
@export var CAKE_2_NAME: String = "Cake2"
@export var CAKE_2_TEXTURE: Texture2D
@export var CAKE_2_RECIPE: Array[String] = ["F", "B"]
@export var CAKE_2_PRICE: int = 1
@export var CAKE_2_POPULARITY: int = 1
@export_subgroup("3")
@export var CAKE_3_NAME: String = "Cake3"
@export var CAKE_3_TEXTURE: Texture2D
@export var CAKE_3_RECIPE: Array[String] = ["F", "B"]
@export var CAKE_3_PRICE: int = 1
@export var CAKE_3_POPULARITY: int = 1
@export_subgroup("Upgrade")
@export var CAKE_PRICE_BASE: int = 5
@export var CAKE_PRICE_SCALE: int = 5
@export var CAKE_INITIAL_LEVEL: int = 0
@export var CAKE_INITIAL_UNLOCK: int = 0

@export_category("Ingredients")
@export_subgroup("Flour")
@export var FLOUR_START_AMOUNT: int = 50
@export var FLOUR_PRICE: int = 5
@export var FLOUR_BUY_AMOUNT: int = 15
@export_subgroup("Butter")
@export var BUTTER_START_AMOUNT: int = 50
@export var BUTTER_PRICE: int = 5
@export var BUTTER_BUY_AMOUNT: int = 15
@export_subgroup("Milk")
@export var MILK_START_AMOUNT: int = 50
@export var MILK_PRICE: int = 5
@export var MILK_BUY_AMOUNT: int = 15
@export_subgroup("Sugar")
@export var SUGAR_START_AMOUNT: int = 50
@export var SUGAR_PRICE: int = 5
@export var SUGAR_BUY_AMOUNT: int = 15

@export_category("Employees")
@export var SERVER_WAGE_BASE: int = 5
@export var SERVER_WAGE_SCALE: int = 5
@export var SERVER_SPEED_BASE: float = 0.25
@export var SERVER_SPEED_SCALE: float = 0.25
@export_subgroup("Server")
@export var SERVER_PRICE_BASE: int = 5
@export var SERVER_PRICE_SCALE: int = 5
@export var SERVER_INITIAL_LEVEL: int = 0
@export var SERVER_INITIAL_UNLOCK: int = 0


static var new_game: bool = true
static var money: int
static var popularity: int
static var enemy_popularity: int
static var ingredient_dict: Dictionary
static var ingredients: Array[Ingredient]
static var restock_purchaseables: Array[RestockPurchaseable]
static var purchaseables: Array[Purchaseable]
static var pastries: Array[Product]
static var coffees: Array[Product]
static var teas: Array[Product]
static var cakes: Array[Product]
static var null_product: Product = Product.new("null", Texture2D.new(), [], 0, 0)

# TODO more stuff i gotta fix later
@onready var queue_path = $Inside/QueuePath
@onready var counter_display = $Inside/Counter

# TODO FIX THIS CLEAN IT UP
@onready var morning_ui = $MorningUI
@onready var shop_menu = $MorningUI/ShopMenu
@onready var restock_bar = $MorningUI/ShopMenu/Row/Column1
@onready var upgrade_bar = $MorningUI/ShopMenu/Row/Column2
@onready var employee_bar = $MorningUI/ShopMenu/Row/Column3
@onready var money_display = $MorningUI/moneybg/Money
@onready var morning_ingredient_label = $MorningUI/ingredientbg/IngredientLabel

# TODO UBER JANK DEV UI REALLY REALLY FIX'
@onready var day_ui = $GameUI
@onready var progress_bar = $GameUI/ProgressBar
@onready var day_ingredient_label = $GameUI/IngredientLabel
@onready var product_label = $GameUI/ProductLabel
@onready var customer_label = $GameUI/CustomerLabel
@onready var auto_serve_display = $GameUI/AutoServeDisplay
@onready var auto_serve_progress_bar = $GameUI/AutoServeDisplay/AutoServe
@onready var day_cycle_progress_bar = $GameUI/DayProgressBar

# TODO fix this also
@onready var overview_ui = $DayOverUI
@onready var stat_list = $DayOverUI/Overview/StatList

@onready var outside = $day_parent

static var server: bool:
	get:
		return purchaseables[4].count >= 1

static var popularity_split: float:
	get:
		return float(popularity) / (float(popularity) + float(enemy_popularity))

var progress: float = 0.0
var customers: Array[Customer] = []

var customer_timer: float = 0.0

var auto_serve_progress: float = 0.0

var day_cycle_progress: float = 0.0

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

var stat_customers: int = 0
var stat_products: int = 0
var stat_popularity: int = 0
var stat_money_in: int = 0
var stat_money_out: int = 0

static func create_ingredient(ingredient_name: String, start_count: int, initial: String) -> Ingredient:
	var new_ingredient = Ingredient.new(ingredient_name, start_count)
	ingredient_dict[initial] = new_ingredient
	return new_ingredient

static func create_product(p_product_name: String, p_texture: Texture2D, p_initials_recipe: Array[String], p_price: int, p_popularity: int) -> Product:
	return Product.new(p_product_name, p_texture, generate_recipe(p_initials_recipe), p_price, p_popularity)

static func generate_recipe(initials_recipe: Array[String]) -> Array[Ingredient]:
	var recipe: Array[Ingredient] = []
	for initial in initials_recipe:
		var true_initial: String
		var count: int
		if len(initial) > 1:
			true_initial = initial[-1]
			count = int(initial.trim_suffix(true_initial))
		else:
			true_initial = initial
			count = 1
		for i in range(count):
			recipe.append(ingredient_dict[true_initial])
	return recipe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outside.can_spawn = false
	$Camera.visible = false
	$Inside/QueuePath.customer_clicked.connect(func(): _start_serving_customer())
	$day_parent/inside.station_reached.connect(_on_station_reach)
	#if WRAPPER.day >= 1 and WRAPPER.day <= 3:
		#DAY_LENGTH = 40
	
	if new_game:
		_generate_new_game()
		new_game = false
	
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
		spend_money(SERVER_WAGE_BASE + SERVER_WAGE_SCALE * purchaseables[4].count)
	
	_update_popularities()
	
	update_current_products()
	update_money_display()
	WRAPPER.friendly_shop_entered.connect(_create_customer)

func _update_popularities() -> void:
	enemy_popularity += ENEMY_POPULARITY_GROWTH
	enemy_popularity -= int(floor(0.1 * enemy_popularity))
	popularity -= int(floor(0.1 * popularity))
	print("Player Popularity: " + str(popularity))
	print("Enemy Popularity: " + str(enemy_popularity))
	print("Popularity Split: " + str(popularity_split))

func _generate_new_game() -> void:
	money = STARTING_MONEY
	popularity = STARTING_POPULARITY
	enemy_popularity = ENEMY_STARTING_POPULARITY
	ingredient_dict = {}
	ingredients = [
	create_ingredient("Flour", FLOUR_START_AMOUNT, "F"),
	create_ingredient("Butter", BUTTER_START_AMOUNT, "B"),
	create_ingredient("Milk", MILK_START_AMOUNT, "M"),
	create_ingredient("Sugar", SUGAR_START_AMOUNT, "S")
	]
	restock_purchaseables = [
	RestockPurchaseable.new("Flour", FLOUR_PRICE, ingredient_dict.F, FLOUR_BUY_AMOUNT),
	RestockPurchaseable.new("Butter", BUTTER_PRICE, ingredient_dict.B, BUTTER_BUY_AMOUNT),
	RestockPurchaseable.new("Milk", MILK_PRICE, ingredient_dict.M, MILK_BUY_AMOUNT),
	RestockPurchaseable.new("Sugar", SUGAR_PRICE, ingredient_dict.S, SUGAR_BUY_AMOUNT)
	]
	purchaseables = [
	Purchaseable.new("Pastry", PASTRY_PRICE_BASE, PASTRY_PRICE_SCALE, PASTRY_INITIAL_LEVEL, PASTRY_INITIAL_UNLOCK),
	Purchaseable.new("Coffee", COFFEE_PRICE_BASE, COFFEE_PRICE_SCALE, COFFEE_INITIAL_LEVEL, COFFEE_INITIAL_UNLOCK),
	Purchaseable.new("Tea", TEA_PRICE_BASE, TEA_PRICE_SCALE, TEA_INITIAL_LEVEL, TEA_INITIAL_UNLOCK),
	Purchaseable.new("Cake", CAKE_PRICE_BASE, CAKE_PRICE_SCALE, CAKE_INITIAL_LEVEL, CAKE_INITIAL_UNLOCK),
	Purchaseable.new("Server", SERVER_PRICE_BASE, SERVER_PRICE_SCALE, SERVER_INITIAL_LEVEL, SERVER_INITIAL_UNLOCK)
	]
	pastries = [
	create_product(PASTRY_1_NAME, PASTRY_1_TEXTURE, PASTRY_1_RECIPE, PASTRY_1_PRICE, PASTRY_1_POPULARITY),
	create_product(PASTRY_2_NAME, PASTRY_2_TEXTURE, PASTRY_2_RECIPE, PASTRY_2_PRICE, PASTRY_2_POPULARITY),
	create_product(PASTRY_3_NAME, PASTRY_3_TEXTURE, PASTRY_3_RECIPE, PASTRY_3_PRICE, PASTRY_3_POPULARITY)
	]
	coffees = [
	create_product(COFFEE_1_NAME, COFFEE_1_TEXTURE, COFFEE_1_RECIPE, COFFEE_1_PRICE, COFFEE_1_POPULARITY),
	create_product(COFFEE_2_NAME, COFFEE_2_TEXTURE, COFFEE_2_RECIPE, COFFEE_2_PRICE, COFFEE_2_POPULARITY),
	create_product(COFFEE_3_NAME, COFFEE_3_TEXTURE, COFFEE_3_RECIPE, COFFEE_3_PRICE, COFFEE_3_POPULARITY)
	]
	teas = [
	create_product(TEA_1_NAME, TEA_1_TEXTURE, TEA_1_RECIPE, TEA_1_PRICE, TEA_1_POPULARITY),
	create_product(TEA_2_NAME, TEA_2_TEXTURE, TEA_2_RECIPE, TEA_2_PRICE, TEA_2_POPULARITY),
	create_product(TEA_3_NAME, TEA_3_TEXTURE, TEA_3_RECIPE, TEA_3_PRICE, TEA_3_POPULARITY)
	]
	cakes = [
	create_product(CAKE_1_NAME, CAKE_1_TEXTURE, CAKE_1_RECIPE, CAKE_1_PRICE, CAKE_1_POPULARITY),
	create_product(CAKE_2_NAME, CAKE_2_TEXTURE, CAKE_2_RECIPE, CAKE_2_PRICE, CAKE_2_POPULARITY),
	create_product(CAKE_3_NAME, CAKE_3_TEXTURE, CAKE_3_RECIPE, CAKE_3_PRICE, CAKE_3_POPULARITY)
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if day_started and not day_ended:
		_day_cycle_process(time_scale * delta)
		_server_process(time_scale * delta)
		_manual_state_process(time_scale * delta)
		_customer_process(time_scale * delta)
		counter_display.update_counter(counter)
	_update_labels()


func _day_cycle_process(delta) -> void:
	day_cycle_progress += delta
	day_cycle_progress_bar.value = day_cycle_progress
	day_cycle_progress_bar.max_value = DAY_LENGTH
	if (not day_ended) and day_cycle_progress > DAY_LENGTH:
		day_ended = true
	if day_ended:
		if len(customers) == 0:
			print("Money: $" + str(money))
			day_ui.visible = false
			$Camera.visible = false
			overview_ui.visible = true
			_generate_overview_menu()

func _server_process(delta) -> void:
	if server:
		if can_serve_customer():
			auto_serve_progress += (SERVER_SPEED_BASE + SERVER_SPEED_SCALE * purchaseables[4].count) + delta
			var duration = SERVING_TIME
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
			var duration = PRODUCTION_TIME
			progress += delta
			if progress >= duration:
				pastry.produce()
				counter.append(pastry)
				_clear_state()
			progress_bar.value = progress / duration
		STATES.COFFEE:
			var duration = PRODUCTION_TIME
			progress += delta
			if progress >= duration:
				coffee.produce()
				counter.append(coffee)
				_clear_state()
			progress_bar.value = progress / duration
		STATES.TEA:
			var duration = PRODUCTION_TIME
			progress += delta
			if progress >= duration:
				tea.produce()
				counter.append(tea)
				_clear_state()
			progress_bar.value = progress / duration
		STATES.CAKE:
			var duration = PRODUCTION_TIME
			progress += delta
			if progress >= duration:
				cake.produce()
				counter.append(cake)
				_clear_state()
			progress_bar.value = progress / duration
		STATES.MANUAL_SERVING: 
			var duration = SERVING_TIME
			progress += delta
			if progress >= duration:
				_serve_customer()
				_clear_state()
			progress_bar.value = progress / duration

func _customer_process(delta) -> void:
	for i in range(len(customers)):
		customers[i].position = clamp(customers[i].position - 25.0 * delta, 15.0 * i, 200.0)
		var patience_decay_rate = PATIENCE_DECAY
		if customers[i].position > 0:
			patience_decay_rate *= IN_LINE_MULT
		customers[i].patience -= patience_decay_rate * delta
	if len(customers) > 0:
		if len(customers[0].order) == 0:
			stat_customers += 1
			customers.pop_front()
		elif customers[0].patience < 0.0:
			customers.pop_front()
	
	queue_path.update_customers(customers)
	var current_order = ""
	var patience = ""
	if len(customers) > 0:
		if customers[0].position == 0.0:
			for item: Product in customers[0].order:
				current_order += item.name + " "
			patience = str(floor(customers[0].patience))
	customer_label.text = "Current Order: " + current_order + "\nPatience: " + patience

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

func _create_customer() -> void:
	if not day_ended:
		var order = []
		for i in range(randi_range(1, 4)):
			var new_order_product = _rand_product()
			while new_order_product == null_product and len(order) == 0:
				new_order_product = _rand_product()
			if not new_order_product == null_product:
				order.append(new_order_product)
		var c = Customer.new(order, INITIAL_PATIENCE)
		customers.append(Customer.new(order, INITIAL_PATIENCE))

func _rand_product() -> Product:
	match randi_range(1, 4):
		1:
			return pastry
		2:
			return coffee
		3:
			return tea
		4:
			return cake
	return null_product

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
	stat_money_in += amount
	update_money_display()

func spend_money(amount) -> void:
	money -= amount
	stat_money_out += amount
	update_money_display()

func earn_popularity(amount) -> void:
	popularity += amount
	stat_popularity += amount

func attempt_purchase(purchaseable) -> void:
	purchaseable.attempt_purchase(money)

func _create_purchaseable_button(purchaseable: Purchaseable) -> Node:
	purchaseable.spent.connect(spend_money)
	var new_purchaseable_button = purchaseable_button_scene.instantiate()
	new_purchaseable_button.set_purchaseable(purchaseable)
	new_purchaseable_button.purchaseable_pressed.connect(attempt_purchase)
	return new_purchaseable_button

func _add_stat_display(stat_name: String, stat_value: String) -> void:
	var new_stat_display = stat_display_scene.instantiate()
	stat_list.add_child(new_stat_display)
	new_stat_display.update_display(stat_name, stat_value)

func _start_serving_customer() -> void:
	if state == STATES.NONE and can_serve_customer():
		state = STATES.MANUAL_SERVING

func _serve_customer() -> bool:
	var items_served: Array[Product] = []
	var no_items: bool = false
	var money_gain: int = 0
	var popularity_gain: int = 0
	while not no_items:
		no_items = true
		for i in range(len(customers[0].order)):
			var current_order = customers[0].order[i]
			if current_order in counter:
				money_gain += current_order.sell_value + int(floor(customers[0].patience / 10.0))
				popularity_gain += current_order.popularity_value + int(floor(customers[0].patience / 10.0))
				items_served.append(current_order)
				counter.erase(current_order)
				customers[0].order.remove_at(i)
				no_items = false
				break
	if len(items_served) > 0:
		earn_money(money_gain)
		earn_popularity(popularity_gain)
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
		counter_display.serve_items(items_served)
	
	customers[0].patience += PATIENCE_ON_SERVE
	stat_products += len(items_served)
	return len(items_served) > 0

func can_serve_customer() -> bool:
	if len(customers) > 0:
		if customers[0].position == 0.0:
			for item: Product in customers[0].order:
				if item in counter:
						return true
	return false

func counter_full() -> bool:
	return len(counter) >= 4

func _generate_overview_menu() -> void:
	_add_stat_display("Customers Satisfied:", str(stat_customers))
	_add_stat_display("Products Served:", str(stat_products))
	_add_stat_display("Popularity Gained:", str(stat_popularity))
	_add_stat_display("Revenue:", str(stat_money_in))
	_add_stat_display("Expenses:", str(stat_money_out))
	_add_stat_display("Profit:", str(stat_money_in - stat_money_out))
	_add_stat_display("Total Money:", str(money))

func _on_quit_pressed() -> void:
	WRAPPER.change_scene(WRAPPER.SCENES.DEBUG) #TODO gotta make a real pause menu

func _on_start_day_pressed() -> void:
	outside.can_spawn = true
	day_started = true
	$Camera.visible = true
	morning_ui.visible = false
	day_ui.visible = true
	update_current_products()
	auto_serve_display.visible = server

func _on_station_reach(station: Inside.STATIONS):
	match station:
		Inside.STATIONS.NONE:
			pass
		Inside.STATIONS.TRASH:
			_on_trash_pressed()
		Inside.STATIONS.SANDWICH:
			_on_pastry_pressed()
		Inside.STATIONS.CAKE:
			_on_cake_pressed()
		Inside.STATIONS.TEA:
			_on_tea_pressed()
		Inside.STATIONS.COFFEE:
			_on_coffee_pressed()

func _on_trash_pressed() -> void:
	counter.pop_front()

func _on_pastry_pressed() -> void:
	if pastry.can_produce() and not counter_full() and WRAPPER.purchaseables[0].unlocked:
		_attempt_enter_state(STATES.PASTRY)

func _on_coffee_pressed() -> void:
	if coffee.can_produce() and not counter_full() and WRAPPER.purchaseables[1].unlocked:
		_attempt_enter_state(STATES.COFFEE)

func _on_tea_pressed() -> void:
	if tea.can_produce() and not counter_full() and WRAPPER.purchaseables[2].unlocked:
		_attempt_enter_state(STATES.TEA)

func _on_cake_pressed() -> void:
	if cake.can_produce() and not counter_full() and WRAPPER.purchaseables[3].unlocked:
		_attempt_enter_state(STATES.CAKE)

func _on_end_day_pressed() -> void:
	WRAPPER.change_scene(WRAPPER.SCENES.DUSK)

func _on_camera_toggled(toggled_on: bool) -> void:
	day_ui.visible = not toggled_on
	outside.switch_camera()

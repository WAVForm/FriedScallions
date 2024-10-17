extends Node2D

# TODO FIX THIS CLEAN IT UP
@onready var item1_button = $GameUI/HBoxContainer/Item1
@onready var item2_button = $GameUI/HBoxContainer/Item2
@onready var server_button = $GameUI/HBoxContainer/Server
@onready var advertisement_button = $GameUI/HBoxContainer/Advertisement
@onready var money_display = $GameUI/Money

# TODO UBER JANK DEV UI REALLY REALLY FIX
@onready var progress_bar = $GameWorld/ProgressBar
@onready var item1_label = $GameWorld/Item1Label
@onready var item2_label = $GameWorld/Item2Label
@onready var customer_label = $GameWorld/CustomerLabel
@onready var hire_button = $GameWorld/Hire
@onready var auto_serve_display = $GameWorld/AutoServeDisplay
@onready var auto_serve_progress_bar = $GameWorld/AutoServeDisplay/AutoServe
@onready var day_cycle_progress_bar = $GameWorld/ProgressBar2

var item1_upgrade
var item2_upgrade
var server_upgrade
var advertisement_upgrade

var money: int = 100
var item1: int = 0
var item2: int = 0

var server: bool = false

var state: String = "None"
var progress: float = 0.0
var customers: Array = []

var customer_timer: float = 5.0

var auto_serve_progress: float = 0.0
var server_payment_progress: float = 0.0

var day_cycle_progress: float = 0.0
var day_cycle_length: int = 60

var time_scale: float = 1.0

signal day_exit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item1_upgrade = _create_purchaseable("Item1", 25, 25)
	item1_button.set_purchaseable(item1_upgrade)
	item1_button.purchaseable_pressed.connect(attempt_purchase)
	item2_upgrade = _create_purchaseable("Item2", 25, 25)
	item2_button.set_purchaseable(item2_upgrade)
	item2_button.purchaseable_pressed.connect(attempt_purchase)
	server_upgrade = _create_purchaseable("Serving", 0, 20)
	server_button.set_purchaseable(server_upgrade)
	server_button.purchaseable_pressed.connect(attempt_purchase)
	advertisement_upgrade = _create_purchaseable("Post Ad", 10)
	advertisement_button.set_purchaseable(advertisement_upgrade)
	advertisement_button.purchaseable_pressed.connect(attempt_purchase)
	update_money_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	day_cycle_progress += delta
	day_cycle_progress_bar.value = day_cycle_progress
	day_cycle_progress_bar.max_value = day_cycle_length
	if day_cycle_progress > day_cycle_length:
		day_exit.emit()
	customer_timer -= delta
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
	if customer_timer <= 0.0:
		customer_timer += 5.0 / (1.0 + 0.1 * advertisement_upgrade.count)
		customers.append(Customer.new())
	if state != "None":
		var duration = 1.0
		if state == "Serving":
			duration = 5.0 / (5.0 + server_upgrade.count)
		progress += delta
		if progress >= duration:
			match state:
				"Item1":
					item1 += item1_upgrade.count
				"Item2":
					item2 += item2_upgrade.count
				"Serving":
					_serve_customer()
			_clear_state()	
		progress_bar.value = progress / duration
	for i in range(len(customers)):
		customers[i].position = clamp(customers[i].position - 50.0 * delta, 30.0 * i, 200.0)
		if customers[i].position == 0:
			if state != "Serving":
				customers[i].patience -= 2.0 * delta
		else:
			customers[i].patience -= 1.0 * delta
		queue_redraw()
	if len(customers) > 0:
		if len(customers[0].order) == 0:
			customers.pop_front()
		elif customers[0].patience < 0.0:
			customers.pop_front()
	item1_label.text = "Item1 Stock: " + str(item1)
	item2_label.text = "Item2 Stock: " + str(item2)
	
	var current_order = ""
	var patience = ""
	if len(customers) > 0:
		if customers[0].position == 0.0:
			current_order = str(customers[0].order)
			patience = str(floor(customers[0].patience))
	
	customer_label.text = "Current Order: " + current_order + "\nPatience: " + patience + "\nCustomers in line: " + str(len(customers))

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

func _clear_state():
	state = "None"
	progress = 0.0

func update_money_display():
	money_display.text = "Money: $" + str(money)

func earn_money(amount):
	money += amount
	update_money_display()

func spend_money(amount):
	money -= amount
	update_money_display()

func attempt_purchase(purchaseable):
	purchaseable.attempt_purchase(money)

func _create_purchaseable(purchaseable_name: String = "", initial_cost: int = 0, cost_per_count: int = 10) -> Purchaseable:
	var new_purchaseable = Purchaseable.new(purchaseable_name, initial_cost, cost_per_count)
	new_purchaseable.spent.connect(spend_money)
	return new_purchaseable


func _make_item1() -> void:
	if state == "None":
		state = "Item1"

func _make_item2() -> void:
	if state == "None":
		state = "Item2"

func _start_serving_customer() -> void:
	if state == "None" and _customer_servable():
		state = "Serving"

func _serve_customer() -> void:
	for i in range(len(customers[0].order)):
		match customers[0].order[i]:
			"Item1":
				if item1 > 0:
					item1 -= 1
					customers[0].order.remove_at(i)
					earn_money(5 + int(floor(customers[0].patience / 10.0)))
					break
			"Item2":
				if item2 > 0:
					item2 -= 1
					customers[0].order.remove_at(i)
					earn_money(5 + int(floor(customers[0].patience / 10.0)))
					break

func _customer_servable() -> bool:
	if len(customers) > 0:
		if customers[0].position == 0.0:
			for item in customers[0].order:
				match item:
					"Item1":
						if item1 > 0:
							return true
					"Item2":
						if item2 > 0:
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
	day_exit.emit()

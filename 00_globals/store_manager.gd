extends Node

signal sold_products( total_sales : float )
signal stock_changed

var sales : float = 0
var items_sold : int = 0

var product_lost : float = 0
var theft_count : int = 0

var customers_gained : int = 0
var customers_lost : int = 0

enum ProductType {
	Banana,
	Bread,
	Butter,
	Dragonfruit,
	Potato,
	Meat,
	Tomato
}

var total_products = 7

var inventory : Dictionary = {}

var total_stock : int = 00

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.game_started.connect(start_new_day)
	start_new_day()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_new_day() -> void:
	total_stock = 0
	items_sold = 0
	
	customers_gained = 0
	customers_lost = 0
	
	restock_inventory()
	erase_thefts()

func restock_inventory() -> void:
	inventory = {
		ProductType.Banana : ["Banana", randi_range(10, 20), 9.95],
		ProductType.Bread : ["Bread", randi_range(10, 20), 9.95],
		ProductType.Butter : ["Butter", randi_range(10, 20), 9.95],
		ProductType.Dragonfruit : ["Dragonfruit", randi_range(10, 20), 9.95],
		ProductType.Meat : ["Meat", randi_range(10, 20), 9.95],
		ProductType.Potato : ["Squid", randi_range(10, 20), 9.95],
		ProductType.Tomato : ["Tomato", randi_range(10, 20), 9.95],
	}
	
	for product_data in inventory.values():
		total_stock += product_data[1]

func restock_inventory_test() -> void:
	inventory = {
		ProductType.Banana : ["Banana", 0, 9.95],
		ProductType.Bread : ["Bread", 0, 9.95],
		ProductType.Butter : ["Butter", 0, 9.95],
		ProductType.Dragonfruit : ["Dragonfruit", 0, 9.95],
		ProductType.Meat : ["Meat", 0, 9.95],
		ProductType.Potato : ["Squid", 0, 9.95],
		ProductType.Tomato : ["Tomato", 0, 9.95],
	}
	
	for product_data in inventory.values():
		total_stock += product_data[1]
	
func erase_thefts() -> void:
	product_lost = 0
	theft_count = 0
		
func buy_products(products : Array[ProductType]) -> void:
	for product_id in products:
		var product_info = inventory[product_id]
		sales += product_info[2]
		items_sold += 1
		
	sold_products.emit(sales)
	customers_gained += 1

func has_product(product_id : ProductType) -> bool:
	var product_info : Array = StoreManager.inventory[product_id]
	var product_qty : int = product_info[1]
	return product_qty > 0

func take_product(product_id : ProductType) -> void:
	var product_info : Array = StoreManager.inventory[product_id]
	var new_product_info : Array = [product_info[0], product_info[1] - 1, product_info[2]]
	inventory[product_id] = new_product_info
	total_stock -= 1
	stock_changed.emit()

func return_product(product_id : ProductType) -> void:
	var product_info : Array = StoreManager.inventory[product_id]
	var new_product_info : Array = [product_info[0], product_info[1] + 1, product_info[2]]
	StoreManager.inventory[product_id] = new_product_info
	StoreManager.total_stock += 1
	stock_changed.emit()

func steal_products(products : Array[ProductType]) -> void:
	print("Product Stolen")
	for product_id in products:
		var product_info = inventory[product_id]
		product_lost += product_info[2]
		theft_count += 1

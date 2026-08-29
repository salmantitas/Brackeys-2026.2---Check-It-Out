class_name Inventory

var inventory : Dictionary
signal inventory_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = {}

func add_product(product_name : String, quantity : int = 1) -> void:
	inventory.get_or_add(product_name)
	
	if inventory[product_name] == null:
		inventory[product_name] = quantity
	else:
		inventory[product_name] += quantity
	
	inventory_changed.emit()

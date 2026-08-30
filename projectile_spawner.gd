extends Node2D

var projectiles : Dictionary[Node2D, Vector2]
@export var projectile_velocity : Vector2 = Vector2(10, 10)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.product_taken.connect(_on_product_taken)
	SignalBus.product_returned.connect(_on_product_returned)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if projectiles.size() <= 0:
		return
	
	for projectile in projectiles:
		var target : Vector2 = projectiles.get(projectile)
		var dir : Vector2 = projectile.global_position.direction_to(target)
		
		projectile.global_position += dir * projectile_velocity
		
		if abs(projectile.global_position.distance_to(target)) <= 10:
			projectiles.erase(projectile)
			projectile.queue_free()

func _on_product_taken(product_id : StoreManager.ProductType, npc : NPC) -> void:
	var PRODUCT : PackedScene
	
	if product_id == StoreManager.ProductType.Banana:
		PRODUCT = preload("uid://cdsx8h1ubomlr")
	if product_id == StoreManager.ProductType.Bread:
		PRODUCT = preload("uid://bw71ktv7mbopi")
	if product_id == StoreManager.ProductType.Butter:
		PRODUCT = preload("uid://c68cslj2sxh42")
	if product_id == StoreManager.ProductType.Dragonfruit:
		PRODUCT = preload("uid://otimqgipnnhl")
	if product_id == StoreManager.ProductType.Meat:
		PRODUCT = preload("uid://blb2xn7rvl1kx")
	if product_id == StoreManager.ProductType.Squid:
		PRODUCT = preload("uid://cne2egskv7lkt")
	if product_id == StoreManager.ProductType.Tomato:
		PRODUCT = preload("uid://bbjoxtx0fr7gq")
		
	var projectile : Node2D = PRODUCT.instantiate()
	add_child(projectile)
	projectile.global_position = global_position + Vector2(randf_range(-10, 10), randf_range(-100, 100))
	projectiles.get_or_add(projectile, npc.global_position)

func _on_product_returned(product_id : StoreManager.ProductType, npc : NPC) -> void:
	var PRODUCT : PackedScene
	
	if product_id == StoreManager.ProductType.Banana:
		PRODUCT = preload("uid://cdsx8h1ubomlr")
	if product_id == StoreManager.ProductType.Bread:
		PRODUCT = preload("uid://bw71ktv7mbopi")
	if product_id == StoreManager.ProductType.Butter:
		PRODUCT = preload("uid://c68cslj2sxh42")
	if product_id == StoreManager.ProductType.Dragonfruit:
		PRODUCT = preload("uid://otimqgipnnhl")
	if product_id == StoreManager.ProductType.Meat:
		PRODUCT = preload("uid://blb2xn7rvl1kx")
	if product_id == StoreManager.ProductType.Squid:
		PRODUCT = preload("uid://cne2egskv7lkt")
	if product_id == StoreManager.ProductType.Tomato:
		PRODUCT = preload("uid://bbjoxtx0fr7gq")
		
	var projectile : Node2D = PRODUCT.instantiate()
	add_child(projectile)
	projectile.global_position = npc.global_position
	projectiles.get_or_add(projectile, global_position)

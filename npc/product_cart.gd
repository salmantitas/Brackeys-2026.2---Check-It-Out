extends CanvasLayer

@onready var cancel_button: TextureButton = $CancelButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var banana: Control = $ProductDisplay/Banana
@onready var bread: Control = $ProductDisplay/Bread
@onready var butter: Control = $ProductDisplay/Butter
@onready var dragonfruit: Control = $ProductDisplay/Dragonfruit
@onready var meat: Control = $ProductDisplay/Meat
@onready var squid: Control = $ProductDisplay/Squid
@onready var tomato: Control = $ProductDisplay/Tomato

@onready var banana_count: Label = $ProductDisplay/Banana/BananaCount
@onready var bread_count: Label = $ProductDisplay/Bread/BreadCount
@onready var butter_count: Label = $ProductDisplay/Butter/ButterCount
@onready var dragonfruit_count: Label = $ProductDisplay/Dragonfruit/DragonfruitCount
@onready var meat_count: Label = $ProductDisplay/Meat/MeatCount
@onready var squid_count: Label = $ProductDisplay/Squid/SquidCount
@onready var tomato_count: Label = $ProductDisplay/Tomato/TomatoCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cancel_button.pressed.connect(_on_cancel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_label(npc : NPC) -> void:
	process_product_cart_to_string(npc)

func process_product_cart_to_string(npc : NPC) -> void:
	
	var count : int = npc.products_cart.count(StoreManager.ProductType.Banana)
	if npc.products_cart.count(count) == 0:
		banana_count.text = str(count)#butter.hide()
	else:
		banana_count.text = str(count)
	
	count = npc.products_cart.count(StoreManager.ProductType.Butter)
	if npc.products_cart.count(count) == 0:
		butter_count.text = str(count)#butter.hide()
	else:
		butter_count.text = str(count)
	
	count = npc.products_cart.count(StoreManager.ProductType.Bread)
	if npc.products_cart.count(count) == 0:
		bread_count.text = str(count)#butter.hide()
	else:
		bread_count.text = str(count)
	
	count = npc.products_cart.count(StoreManager.ProductType.Dragonfruit)
	if npc.products_cart.count(count) == 0:
		dragonfruit_count.text = str(count)#butter.hide()
	else:
		dragonfruit_count.text = str(count)
	
	count = npc.products_cart.count(StoreManager.ProductType.Meat)
	if npc.products_cart.count(count) == 0:
		meat_count.text = str(count)#butter.hide()
	else:
		meat_count.text = str(count)
	
	count = npc.products_cart.count(StoreManager.ProductType.Potato)
	if npc.products_cart.count(count) == 0:
		squid_count.text = str(count)#butter.hide()
	else:
		squid_count.text = str(count)
	
	count = npc.products_cart.count(StoreManager.ProductType.Tomato)
	if npc.products_cart.count(count) == 0:
		tomato_count.text = str(count)#butter.hide()
	else:
		tomato_count.text = str(count)

func display() -> void:
	SignalBus.inspection_started.emit()
	$".".show()
	animation_player.play("check_cart")

func _on_cancel() -> void:
	animation_player.play("cart_away")
	get_tree().paused = false
	SignalBus.inspection_ended.emit()

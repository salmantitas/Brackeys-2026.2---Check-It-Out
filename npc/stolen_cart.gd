extends CanvasLayer

@onready var cancel_button: TextureButton = $CancelButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var banana_sprite: Sprite2D = $ProductDisplay/BananaSprite
@onready var bread_sprite: Sprite2D = $ProductDisplay/BreadSprite
@onready var butter_sprite: Sprite2D = $ProductDisplay/ButterSprite
@onready var dragonfruit_sprite: Sprite2D = $ProductDisplay/DragonfruitSprite
@onready var meat_sprite: Sprite2D = $ProductDisplay/MeatSprite
@onready var squid_sprite: Sprite2D = $ProductDisplay/SquidSprite
@onready var tomato_sprite: Sprite2D = $ProductDisplay/TomatoSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.setup_button_audio(self)
	cancel_button.pressed.connect(_on_cancel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display() -> void:
	SignalBus.inspection_started.emit()
	$".".show()
	animation_player.play("check_pocket")

func update_label(npc : NPC) -> void:
	display_stolen_products(npc)

func display_stolen_products(npc : NPC) -> void:
	var count : int = npc.products_stolen.count(StoreManager.ProductType.Banana)
	
	if count > 0:
		banana_sprite.show()
	else:
		banana_sprite.hide()
	
	count = npc.products_stolen.count(StoreManager.ProductType.Bread)
	
	if count > 0:
		bread_sprite.show()
	else:
		bread_sprite.hide()
		
	count = npc.products_stolen.count(StoreManager.ProductType.Butter)
	
	if count > 0:
		butter_sprite.show()
	else:
		butter_sprite.hide()
	
	count = npc.products_stolen.count(StoreManager.ProductType.Dragonfruit)
	
	if count > 0:
		dragonfruit_sprite.show()
	else:
		dragonfruit_sprite.hide()
	
	count = npc.products_stolen.count(StoreManager.ProductType.Squid)
	
	if count > 0:
		squid_sprite.show()
	else:
		squid_sprite.hide()
	
	count = npc.products_stolen.count(StoreManager.ProductType.Meat)
	
	if count > 0:
		meat_sprite.show()
	else:
		meat_sprite.hide()
	
	count = npc.products_stolen.count(StoreManager.ProductType.Tomato)
	
	if count > 0:
		tomato_sprite.show()
	else:
		tomato_sprite.hide()
	
func process_label(npc : NPC) -> String:
	var label_text = ""
	if npc.products_stolen.size() <= 1:
		label_text = "There's something in their pocket, but it could just be their wallet."
	elif npc.products_stolen.size() <= 3:
		label_text = "That's one big phone... Or something..."
	else:
		label_text = "They've clearly stuffed a lot of stuff in their pockets."
	return label_text

func _on_cancel() -> void:
	animation_player.play("cart_away")
	get_tree().paused = false
	SignalBus.inspection_ended.emit()

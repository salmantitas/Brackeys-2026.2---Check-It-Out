extends Sprite2D

@onready var game_counter_till: Sprite2D = $GameCounterTill
@onready var game_counter_checkout: Sprite2D = $GameCounterCheckout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StoreManager.sold_products.connect(_update_till)
	game_counter_checkout.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_till(time : float = 1) -> void:
	Audio.play_spatial_sound(Audio.cash, Vector2.ZERO)
	game_counter_till.hide()
	game_counter_checkout.show()
	await get_tree().create_timer(1.0).timeout
	game_counter_till.show()
	game_counter_checkout.hide()

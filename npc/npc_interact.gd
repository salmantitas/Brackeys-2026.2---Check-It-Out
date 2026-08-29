extends Control

@onready var talk_button: Button = %TalkButton
@onready var cart_button: Button = %CartButton
@onready var shoplift_button: Button = %ShopliftButton

var npc : NPC

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.setup_button_audio(self)
	npc = get_parent()
	talk_button.pressed.connect(_on_talk_button_pressed)
	cart_button.pressed.connect(_on_cart_button_pressed)
	shoplift_button.pressed.connect(_on_shoplift_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_talk_button_pressed() -> void:
	SignalBus.conversation_started.emit(npc)

func _on_cart_button_pressed() -> void:
	npc.interact.hide()
	npc.product_cart.display()
	get_tree().paused = true

func _on_shoplift_button_pressed() -> void:
	npc.interact.hide()
	npc.stolen_cart.display()
	get_tree().paused = true

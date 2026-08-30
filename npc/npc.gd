class_name NPC
extends Sprite2D

var initial_position : int = -1
var dialogue : Dialogue

var shopping_list : Inventory

var products_cart : Array[StoreManager.ProductType]
var products_stolen : Array[StoreManager.ProductType]

var desired_product : StoreManager.ProductType

var assisted : bool = false 
var checkout_complete : bool = false

@onready var speechbox: Control = $Speechbox
@export var browser : bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var steal_chance : float = 0.0
var enraged : float = 0.0

@export var product_pick_interval : float = 1

#region /// States
var state_machine : StateMachine
var decision_engine : DecisionEngine
var blackboard : Blackboard
#endregion

@onready var state_label: Label = %StateLabel
@onready var interact: Control = $Interact
@onready var product_cart: CanvasLayer = $ProductCart
@onready var stolen_cart: CanvasLayer = $StolenCart
@onready var progress_bar: ProgressBar = $Stats/RemainingTime/ProgressBar

var voice_audio : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	randomize_appearance()
	randomize_voice()
	
	shopping_list = Inventory.new()
	generate_shopping_list()
	
	speechbox.hide()
	product_cart.hide()
	stolen_cart.hide()
	interact.hide()

func _physics_process(delta: float) -> void:
	state_machine.change_state(decision_engine.decide())
	state_machine.physics_update(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if get_rect().has_point(to_local(event.position)):
				$Stats.visible = !$Stats.visible

func setup() -> void:
	blackboard = Blackboard.new()
	
	for c in get_children():
		#if c is AnimationPlayer and not animation:
			#animation = c
		#elif c is Sprite2D and not sprite:
			#sprite = c
		if c is StateMachine and not state_machine:
			state_machine = c
		elif c is DecisionEngine and not decision_engine:
			decision_engine = c
		
	if state_machine and decision_engine:
		state_machine.setup(self, blackboard)
		decision_engine.npc = self
		decision_engine.blackboard = blackboard
	else:
		set_physics_process(false)

func randomize_appearance() -> void:	
	var ref_sprite : AnimatedSprite2D = CharacterLibrary.get_sprite()
	
	animated_sprite_2d.sprite_frames = ref_sprite.sprite_frames
	animated_sprite_2d.position = ref_sprite.position
	animated_sprite_2d.scale = ref_sprite.scale

func randomize_voice() -> void:
	var index : int = randi_range(0, Audio.voices_paths.size() - 1)
	voice_audio = load(Audio.voices_paths[index])

func _on_area_2d_mouse_entered() -> void:
	var new_scale : float = 1.1
	change_scale(new_scale, 0.1)
	interact.show()

func _on_area_2d_mouse_exited() -> void:
	var new_scale : float = 1.0
	change_scale(new_scale, 0.1)
	interact.hide()

func change_scale(new_scale : float, time : float = 1) -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(new_scale, new_scale), time)

func set_dialogue(dialogue_path : String) -> void:
	dialogue = load(dialogue_path).instantiate()
	dialogue.setup()

func update_stats(time_left : float) -> void:
	var state_name : String = state_machine.current_state.name
	var state_text = str(state_name, ": %0.2f" % time_left)
	state_label.text = state_text
	
	var state_color = state_machine.current_state.state_color
	progress_bar.modulate = state_color
	progress_bar.max_value = state_machine.current_state.total_timer.wait_time
	progress_bar.value = state_machine.current_state.total_timer.time_left
	product_cart.update_label(self)
	stolen_cart.update_label(self)

func process_stolen_text() -> String:
	var label_text = ""
	if products_stolen.size() <= 1:
		label_text = "There's something in their pocket, but it could just be their wallet."
	elif products_stolen.size() <= 3:
		label_text = "That's one big phone... Or something..."
	else:
		label_text = "They've clearly stuffed a lot of stuff in their pockets."
	return label_text

func add_to_cart() -> void:
	generate_desired_product()
	
	if StoreManager.has_product(desired_product):
		products_cart.append(desired_product)
		StoreManager.take_product(desired_product, self)

func add_to_pocket() -> void:
	animated_sprite_2d.play("steal")
	await get_tree().create_timer(0.1).timeout
	animated_sprite_2d.play("default")
	
	generate_desired_product()
	if StoreManager.has_product(desired_product):
		products_stolen.append(desired_product)
		StoreManager.take_product(desired_product, self)

func buy_products() -> void:
	StoreManager.buy_products(products_cart)
	products_cart = []
	checkout_complete = true

func check_bags() -> void:
	if products_stolen.size() > 0:
		Audio.play_spatial_sound(Audio.alarm, Vector2.ZERO)
	
	for product_id in products_stolen:
		StoreManager.return_product(product_id, self)
		
	for product_id in products_cart:
		StoreManager.return_product(product_id, self)
	products_cart = []
	products_stolen = []
	enraged = 1.0

func generate_shopping_list() -> void:
	for i in StoreManager.total_products:
		var num : int = randi_range(0, 5)
		shopping_list.add_product( StoreManager.inventory[i][0] , num )
	print(shopping_list.inventory)

func display_text(str : String) -> void:
	speechbox.show()
	if global_position.x >= 1000:
		speechbox.flip(true) 
	else:
		speechbox.flip(false) 
	
	speechbox.update_text(str)

func generate_desired_product() -> void:
	desired_product = StoreManager.ProductType.values().pick_random()

func accused() -> void:
	product_pick_interval *= 2
	animated_sprite_2d.play("accused")
	await get_tree().create_timer(1).timeout
	animated_sprite_2d.play("default")

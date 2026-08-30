class_name DialogueManager
extends Control

@onready var responses: VBoxContainer = $VBoxContainer/Responses
var current_npc : NPC
var current_dialogue : Dialogue 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".hide()
	SignalBus.conversation_started.connect(_on_conversation_started)
	SignalBus.conversation_ended.connect(_on_conversation_ended)
	SignalBus.npc_left.connect(_on_npc_left)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_conversation_started(npc : NPC) -> void:
	#get_tree().paused = true
	$".".show()
	current_npc = npc
	set_dialogue(current_npc.dialogue)
	#responses.alignment = BoxContainer.ALIGNMENT_CENTER
	#responses.size_flags_horizontal = Control.SIZE_FILL

func set_dialogue(dialogue : Dialogue) -> void:
	Audio.play_spatial_sound(current_npc.voice_audio, current_npc.global_position)
	current_dialogue = dialogue
	current_dialogue.visit_count += 1
	execute_dialogue()
	
	if current_npc:
		current_npc.display_text(dialogue.line)
	$VBoxContainer/DialogueLabel.text = dialogue.line
	$TopicLabel.text = dialogue.current_dialogue
	clear_responses()
	
	var count : int = 1
	
	#var size : Vector2 = $VBoxContainer.size
	
	for option : Dialogue in dialogue.next_dialogues:
		if option.visitable(current_npc):
			var button : Button = Button.new()
			button.text = str(count, ": ", option.current_dialogue)
			button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			button.add_theme_color_override("font_color", Color())
			button.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
			button.add_theme_font_size_override("font_size", 32)
			Audio.setup_button_audio_helper(button)
			responses.add_child(button)
		
			button.pressed.connect(_on_dialogue_selected.bind(option))
			count += 1
	
	#$VBoxContainer.size = size
	
func _on_dialogue_selected(new_dialogue : Dialogue) -> void:
	#if new_dialogue.get_child_count() == 0:
		#_on_conversation_ended()
		#return
		
	new_dialogue.setup()
	set_dialogue(new_dialogue)

func _on_conversation_ended() -> void:
	for c in responses.get_children():
		if c is Button:
			responses.remove_child(c)
	$".".hide()
	current_npc.speechbox.hide()
	
	current_dialogue = null
	current_npc = null
	
	clear_responses()
	#get_tree().paused = false

func clear_responses() -> void:
	
	for c in responses.get_children():
		c.queue_free()
	

func _on_npc_left (npc : NPC) -> void:
	if npc == current_npc:
		_on_conversation_ended()

func execute_dialogue() -> void:
	if current_dialogue.executible == null:
		return
	
	if current_dialogue.executible == Dialogue.Function.ASSIST:
		current_npc.generate_desired_product()
		var product_name : String = (StoreManager.inventory[current_npc.desired_product])[0]
		current_dialogue.line = "I am looking for " + product_name
		
		if StoreManager.has_product(current_npc.desired_product):
			pass
		else:
			var dlg1 : Dialogue = current_dialogue.get_child(0)
			dlg1.line = "You don't have it."
			
			var dlg2 : Dialogue = current_dialogue.get_child(1)
			dlg2.line = "Oh, too bad."
	
	if current_dialogue.executible == Dialogue.Function.PRODUCT_CHECK_YES:
		if StoreManager.has_product(current_npc.desired_product):
			current_npc.products_cart.append(current_npc.desired_product)
			StoreManager.take_product(current_npc.desired_product, current_npc)
		current_npc.assisted = true
		
	if current_dialogue.executible == Dialogue.Function.PRODUCT_CHECK_NO:
		if StoreManager.has_product(current_npc.desired_product):
			current_npc.products_cart.append(current_npc.desired_product)
			StoreManager.take_product(current_npc.desired_product, current_npc)
		current_npc.assisted = true

	if current_dialogue.executible == Dialogue.Function.CHECKOUT:
		current_npc.buy_products()
	
	if current_dialogue.executible == Dialogue.Function.ACCUSED:
		current_npc.accused()
		if current_npc.products_stolen.size() > 0:
			var dlg : Dialogue = current_dialogue.get_child(0)
			dlg.line = "What!!! How did these show up in my bag?"
		pass
	
	if current_dialogue.executible == Dialogue.Function.BAG_CHECK:
		current_npc.check_bags()
		DayNightCycleManager.time_skip(10)
	
	if current_dialogue.executible == Dialogue.Function.EXIT:
		_on_conversation_ended()

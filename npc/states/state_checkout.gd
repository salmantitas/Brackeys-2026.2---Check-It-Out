class_name StateCheckOut
extends State

const dialogue_checkout_path = "uid://clgvbnosb5ip5"

func enter() -> void: 
	super()
	
	state_color = Color.YELLOW
	
	npc.set_dialogue(dialogue_checkout_path)
	
	total_timer.wait_time = randf_range(state_timer_min, state_timer_max)
	total_timer.start()
	
#	timer.wait_time = randf_range(0.5, 3)
#	timer.start()
#	timer.timeout.connect(_on_timer_timeout)
	
func re_enter() -> void: pass
func exit() -> void: pass
func physics_update( _delta : float ) -> void: pass

func can_enter() -> bool:
	if npc.checkout_complete:
		return false
	elif npc.products_cart.size() > 0:
		return true
	else:
		return false
		#return times_entered == 0 or total_timer.time_left > 0

func _on_total_timer_timeout() -> void:
	total_timer.stop()
	return_products()
	
func return_products() -> void:
	for product_id in npc.products_cart:
		StoreManager.return_product(product_id, npc)
	npc.products_cart = []

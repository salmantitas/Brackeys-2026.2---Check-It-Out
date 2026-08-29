class_name StateLeaving
extends State

const leaving_dialogue_path = "uid://b66dnoxc0ktsd"

func _ready() -> void:
	pass

func enter() -> void: 
	super()
	
	state_color = Color.RED
	
	npc.set_dialogue(leaving_dialogue_path)
	
	total_timer.wait_time = randf_range(state_timer_min, state_timer_max)
	total_timer.start()
	
#	timer.wait_time = randf_range(0.5, 3)
#	timer.start()
#	timer.timeout.connect(_on_timer_timeout)
	
func re_enter() -> void: pass
func exit() -> void: pass
func physics_update( _delta : float ) -> void: pass

func can_enter() -> bool:
	return times_entered == 0 or total_timer.time_left > 0

func _on_total_timer_timeout() -> void:
	SignalBus.position_cleared.emit( npc.global_position.x)
	SignalBus.npc_left.emit(npc)
	StoreManager.steal_products(npc.products_stolen)
	Audio.play_spatial_sound(Audio.npc_exit, Vector2.ZERO)
	npc.queue_free()

func leave_immediately() -> void:
	if total_timer.wait_time > 1:
		total_timer.stop()
		total_timer.wait_time = 1
		total_timer.start()

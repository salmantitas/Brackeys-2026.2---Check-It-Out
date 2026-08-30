class_name StateLeaving
extends State

const leaving_dialogue_path = "uid://b66dnoxc0ktsd"

@export var velocity : Vector2 = Vector2(5, 0)
var dir : float = 1

func _ready() -> void:
	pass

func enter() -> void: 
	super()
	
	state_color = Color.RED
	
	npc.set_dialogue(leaving_dialogue_path)
	
	total_timer.wait_time = randf_range(state_timer_min, state_timer_max)
	total_timer.start()
	
	if abs(npc.global_position.x - 0) < abs(npc.global_position.x - 1920):
		dir = -1
	
#	timer.wait_time = randf_range(0.5, 3)
#	timer.start()
#	timer.timeout.connect(_on_timer_timeout)
	
func re_enter() -> void: pass
func exit() -> void: pass
func physics_update( _delta : float ) -> void:
	if total_timer.wait_time - total_timer.time_left <= 0.5:
		return
	
	if npc.enraged:
		npc.position += velocity * dir * 3
	else:
		npc.position += velocity * dir
	
	

func can_enter() -> bool:
	return times_entered == 0 or total_timer.time_left > 0

func _on_total_timer_timeout() -> void:
	SignalBus.position_cleared.emit( npc.initial_position)
	SignalBus.npc_left.emit(npc)
	StoreManager.steal_products(npc.products_stolen)
	Audio.play_spatial_sound(Audio.npc_exit, Vector2.ZERO)
	npc.queue_free()

func leave_immediately() -> void:
	var time : float = 2
	if total_timer.wait_time > time:
		total_timer.stop()
		total_timer.wait_time = time
		total_timer.start()

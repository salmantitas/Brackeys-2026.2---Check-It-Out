class_name StateStealing
extends State

const dialogue_stealing_path = "uid://dst010afwcv6j"
@onready var timer: Timer = $Timer

func enter() -> void:
	super()
	
	npc.set_dialogue(dialogue_stealing_path)
	
	total_timer.wait_time = randf_range(state_timer_min, state_timer_max)
	total_timer.start()
	
	timer.wait_time = randf_range(0.5, 3)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)
	
func re_enter() -> void: pass
func exit() -> void: pass
func physics_update( _delta : float ) -> void: pass

func _on_timer_timeout() -> void:
	npc.add_to_pocket()
	timer.wait_time = randf_range(2, 3)

func can_enter() -> bool:
	return total_timer.time_left > 0

func _on_total_timer_timeout() -> void:
	stop_timers()

func stop_timers() -> void:
	super()
	timer.stop()

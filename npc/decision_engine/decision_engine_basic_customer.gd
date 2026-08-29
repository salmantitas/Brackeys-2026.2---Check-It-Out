class_name DecisionEngineBasicCustomer
extends DecisionEngine

func _ready() -> void:
	await super() # Maintains important setup code & timing
	# Implement your scripts here
	pass

# Included in DecisionEngine
# var npc : NPC
# var current_state : State
# var blackboard : Blackboard
@onready var browsing: StateBrowsing = $"../StateMachine/Browsing"
@onready var check_out: StateCheckOut = $"../StateMachine/CheckOut"
@onready var leaving: StateLeaving = $"../StateMachine/Leaving"

func decide() -> State:
	npc.update_stats(current_state.total_timer.time_left)
	
	if npc.enraged >= 1.0:
		browsing.stop_timers()
		leaving.leave_immediately()
		return leaving
	
	if browsing.can_enter():
		return browsing # default state
	
	elif check_out.can_enter():
		return check_out
		
	else:
		return leaving

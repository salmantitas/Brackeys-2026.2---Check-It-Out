class_name StateMachine
extends Node

var npc : NPC
var blackboard : Blackboard
var states : Array[State]
var current_state : State :
	get() : 
		return states.front()
var prev_state : State:
	get():
		return states.get(1)

func setup(n : NPC, b : Blackboard) -> void:
	blackboard = b
	npc = n
	for c in get_children():
		if c is State:
			c.npc = n
			c.blackboard = b
			c.state_machine = self
			states.append(c)
	current_state.enter()
	npc.decision_engine.current_state = current_state

func change_state( new_state : State ) -> void:
	if not new_state:
		return
	
	if new_state == current_state:
		current_state.re_enter()
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front(new_state)
	current_state.enter()
	
	if npc:
		npc.decision_engine.current_state = new_state
	states.resize(2)

func physics_update( delta : float ) -> void:
	if current_state:
		current_state.physics_update( delta )

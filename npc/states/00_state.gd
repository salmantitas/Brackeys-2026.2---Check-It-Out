class_name State
extends Node

var state_machine : StateMachine
var npc : NPC
var blackboard : Blackboard

var times_entered : int = 0
@export var state_color : Color = Color.GREEN

@export var dialogue_path : String

@export var state_timer_min : float = 10
@export var state_timer_max : float = 20
@onready var total_timer: Timer = $TotalTimer

func enter() -> void: 
	times_entered += 1
	#npc.set_dialogue(dialogue_path)

func re_enter() -> void: 
	times_entered += 1
	
func exit() -> void: pass
func physics_update( _delta : float ) -> void: pass
func can_enter() -> bool: return true

func stop_timers() -> void:
	total_timer.stop()

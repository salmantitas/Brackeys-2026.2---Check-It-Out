class_name DecisionEngine
extends Node

var npc : NPC
var current_state : State
var blackboard : Blackboard

func _ready() -> void:
	pass
	#while not npc:
	#	await get_tree().process_frame
	#enemy.change_direction(-1 if enemy.face_left_on_start else 1)

func decide() -> State:
	npc.update_stats(0)
	return null

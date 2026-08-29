class_name Dialogue
extends Node

@export var current_dialogue : String = ""
@export var line : String = ""
@export var next_dialogues : Array[Dialogue] = []

var visit_count : int = 0
@export var max_visit_count : int = -1

enum Function{
	NONE,
	ASSIST,
	PRODUCT_CHECK_YES,
	CHECKOUT,
	ACCUSED,
	BAG_CHECK,
	EXIT,
	PRODUCT_CHECK_NO
}

@export var executible : Function = Function.NONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_dialogues = []
	setup()

func setup() -> void:
	if get_child_count() == next_dialogues.size():
		return
	
	for c in get_children():
		next_dialogues.append(c)

func visitable(npc : NPC) -> bool:
	if max_visit_count < 0:
		return true
	else:
		return visit_count < max_visit_count

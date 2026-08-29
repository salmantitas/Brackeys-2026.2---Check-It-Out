extends Node

var day : int = -1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_in_progress() -> bool:
	return day > 0

func set_time() -> void:
	DayNightCycleManager.initial_day = day

func update_day(new_day : int) -> void:
	day = new_day

func game_over() -> void:
	day = -1

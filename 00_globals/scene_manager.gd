extends Node

signal game_started

var eod_scene_path : String = "uid://db3fwtomb4wtb"
var game_scene: String = "uid://c185ubicquv1j"
var title_scene_path: String = "uid://blif0poth6hrf"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DayNightCycleManager.time_tick_day.connect(_end_of_day)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game() -> void:
	get_tree().change_scene_to_file(game_scene)
	game_started.emit()
	DayNightCycleManager.end_of_day = false

func _end_of_day(day : int) -> void:
	get_tree().change_scene_to_file(eod_scene_path)

func load_scene(scene_path : String) -> void:
	get_tree().change_scene_to_file(scene_path)

func return_to_title() -> void:
	load_scene(title_scene_path)

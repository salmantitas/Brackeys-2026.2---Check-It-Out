class_name DayNightCycleComponent
extends CanvasModulate

@export var initial_day : int = 1:
	set(value):
		initial_day = value
		DayNightCycleManager.initial_day = value
		DayNightCycleManager.set_initial_time()

@export var initial_hour : int = 1:
	set(value):
		initial_hour = value
		DayNightCycleManager.initial_hour = value
		DayNightCycleManager.set_initial_time()

@export var initial_minute : int = 1:
	set(value):
		initial_minute = value
		DayNightCycleManager.initial_minute = value
		DayNightCycleManager.set_initial_time()

@export var day_night_gradient_texture : GradientTexture1D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameData.game_in_progress():
		GameData.set_time()
	else:
		DayNightCycleManager.initial_day = initial_day
	DayNightCycleManager.initial_hour = initial_hour
	DayNightCycleManager.initial_minute = initial_minute
	
	DayNightCycleManager.set_initial_time()
	
	DayNightCycleManager.game_time.connect(on_game_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_game_time(time : float) -> void:
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0)
	color = day_night_gradient_texture.gradient.sample(sample_value)

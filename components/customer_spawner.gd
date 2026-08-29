extends Node

var min_x : int = 450
var min_y : int = 740
var max_y : int = 800
var offset : int = 120

var customer_chance = 0.5
var browser_chance = 0.1
var shoplifter_chance = 0.4

var customer_scene : PackedScene = preload("uid://cnuwgufa8yq6g")
var shoplifter_scene : PackedScene = preload("uid://kubv5badugne")
var browser_scene : PackedScene = preload("uid://dsmdd1m7h60or")

@export var min_customers : int = 3
@export var max_customers : int = 5
@export var rush : Curve
var capacity : int = 0

var deadzone : Array

var current_hour : int = -1

@onready var timer: Timer = $Timer

@onready var hud: CanvasLayer = $"../HUD"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.position_cleared.connect(_clear_position)
	timer.set_wait_time(randf_range(1, 2))
	timer.start()
	capacity = 3# max_customers
	DayNightCycleManager.time_tick.connect(_update_current_hour)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	timer.stop()
	timer.wait_time = randf_range(10, 20)
	
	var sample : float = rush.sample( current_hour / 24.00 )
	var lerpf : float = lerp(min_customers, max_customers, sample)
	var lerpi : int = roundi(lerpf)
	
	#capacity = min_customers
	
	if capacity > 0:
		spawn_customers()
	
	if capacity > 0:
		spawn_shoplifters()
	
	if capacity > 0:
		spawn_browsers()
	
	timer.start()

func spawn_customers() -> void:
	var num : int = randi_range(1, capacity)
	
	for i in range(0, num):
		spawn_npc(customer_scene)

func spawn_shoplifters() -> void:
	for i in capacity:
		spawn_npc(shoplifter_scene)

func spawn_browsers() -> void:
	for i in capacity:
		spawn_npc(browser_chance)

func spawn_npc(npc_scene : PackedScene) -> void:
	var npc : NPC = npc_scene.instantiate()
	var spawn_position = Vector2(randi_range(0, max_customers - 1), randi_range(min_y, max_y))
	while deadzone.has(spawn_position.x):
		spawn_position.x = randi_range(0, max_customers - 1)
		print(spawn_position)
	deadzone.append(spawn_position.x)
	npc.global_position = Vector2(min_x + spawn_position.x * offset*2, spawn_position.y)
	
	add_child(npc)
	
	capacity -= 1

func _clear_position( pos_x : float) -> void:
	var deadzone_pos : float = (pos_x - min_x ) / (offset * 2) 
	deadzone.erase(deadzone_pos)
	capacity += 1

func _update_current_hour(day : int, hour : int, minute : int) -> void:
	if current_hour != hour:
		current_hour = hour 

extends CanvasLayer

@onready var total_stock: Label = %TotalStock

@onready var bread_count: Label = %BreadCount
@onready var butter_count: Label = %ButterCount
@onready var dragonfruit_count: Label = %DragonfruitCount
@onready var meat_count: Label = %MeatCount
@onready var squid_count: Label = %SquidCount
@onready var banana_count: Label = %BananaCount
@onready var tomato_count: Label = %TomatoCount
@onready var sale_label: Label = %SaleLabel
@onready var day_label: Label = %DayLabel
@onready var time_label: Label = %TimeLabel
@onready var pause: Sprite2D = $Top/Pause
@onready var pause_button: Button = %PauseButton
@onready var animation_player: AnimationPlayer = $PauseMenu/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.setup_button_audio_helper(pause_button)
	
	StoreManager.sold_products.connect(_update_HUD)
	StoreManager.stock_changed.connect(_update_stock_count)
	$PauseMenu.hide()
	_update_HUD(0)
	_update_stock_count()
	DayNightCycleManager.time_tick.connect(on_time_tick)
	
	SignalBus.inspection_started.connect(_on_inspection_started)
	SignalBus.inspection_ended.connect(_on_inspection_ended)
	
	_on_pause_button_pressed()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_HUD( value : float) -> void:
	sale_label.text = "$%0.2f" % value

func _update_stock_count() -> void:
	total_stock.text = "Total : %d" % StoreManager.total_stock
	
	bread_count.text = str((StoreManager.inventory[0])[1])
	butter_count.text = str((StoreManager.inventory[1])[1])
	dragonfruit_count.text = str((StoreManager.inventory[2])[1])
	meat_count.text = str((StoreManager.inventory[3])[1])
	squid_count.text = str((StoreManager.inventory[4])[1])
	banana_count.text = str((StoreManager.inventory[5])[1])
	tomato_count.text = str((StoreManager.inventory[6])[1])

func _on_count_stock_button_pressed() -> void:
	_update_stock_count()

func on_time_tick(day : int, hour : int, minute : int) -> void:
	day_label.text = "Day " + str(day)
	time_label.text = "%02d:%02d" % [hour, minute]


func _on_pause_button_pressed() -> void:
	var paused : bool = get_tree().paused
	
	if paused == true:
		animation_player.play("unpause")
		pause_button.text = "PAUSE"
	else:
		animation_player.play("pause")
		pause_button.text = "UNPAUSE"
		
	get_tree().paused = !get_tree().paused

func _on_inspection_started() -> void:
	pause_button.hide()

func _on_inspection_ended() -> void:
	pause_button.show()

func _on_title_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.return_to_title()
	

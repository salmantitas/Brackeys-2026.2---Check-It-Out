extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var gross_label: Label = %GrossLabel
@onready var items_sold_label: Label = %ItemsSoldLabel
@onready var customers_gained_label: Label = %CustomersGainedLabel
@onready var taxed_gross_label: Label = %TaxedGrossLabel
@onready var loss_label: Label = %LossLabel
@onready var theft_label: Label = %TheftLabel
@onready var customers_lost_label: Label = %CustomersLostLabel
@onready var salary_label: Label = %SalaryLabel
@onready var total_label: Label = %TotalLabel
@onready var dedn_label: Label = %DednLabel
@onready var net_pay_label: Label = %NetPayLabel

var game_scene : String = "uid://c185ubicquv1j"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.update_day(DayNightCycleManager.current_day)
	
	$Control/EodShutter.hide()
	$Control/Payslip.hide()
	$Control/VBoxContainer.hide()
	#end_of_day_label.text = "END OF DAY %d" % (DayNightCycleManager.current_day - 1)
	gross_label.text = "%.2f" % (StoreManager.sales)
	taxed_gross_label.text = gross_label.text
	total_label.text = gross_label.text
	
	items_sold_label.text = str(StoreManager.items_sold)
	theft_label.text = str(StoreManager.theft_count)
	customers_gained_label.text = str(StoreManager.customers_gained)
	
	loss_label.text = "- %.2f" % (StoreManager.product_lost)
	dedn_label.text = loss_label.text

	salary_label.text = "%.2f" % (StoreManager.sales - StoreManager.product_lost)
	net_pay_label.text = salary_label.text
	
	var str : String = determine_status()
	
	animation_player.play("new_animation")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func determine_status() -> String:
	var status : String = (
		"You've Survived Another Day
		For Better Or For Worse...")
	var won : bool = true
	
	
	var sales_goal : float = 0
	var loss_goal : float = 1000000000
	
	if (StoreManager.sales == 0):
		status = (
			"You Were Fired
			For Not Being Able To Sell Anything!")
		won = false
	
	elif (StoreManager.sales < sales_goal) and (StoreManager.product_lost > loss_goal):
		status = (
			"You Were Fired.
			Not Only Did You Not Meet The Sales Goal...
			You Also Lost Too Many Products")
		won = false
	
	elif StoreManager.sales < sales_goal:
		status = (
			"You Were Fired
			For Not Meeting The Sales Goal")
		won = false
		
	elif StoreManager.product_lost > loss_goal:
		status = (
			"You Were Fired
			For Losing Too Many Products")
		won = false
		
	elif StoreManager.product_lost >= StoreManager.sales:
		status = (
			"You Were Fired
			For Losing Too Many Products")
		won = false
		
	if not won:
		%EodFired.hide()
		%ContinueButton.hide()
		%RestartButton.show()
		game_over()
	else:
		%EodFired.show()
		%ContinueButton.show()
		%RestartButton.hide()
	return status


func _on_continue_button_pressed() -> void:
	SceneManager.start_game()

func _on_restart_button_pressed() -> void:
	SceneManager.start_game()

func game_over() -> void:
	GameData.game_over()

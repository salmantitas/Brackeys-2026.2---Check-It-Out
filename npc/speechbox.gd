extends Control
@onready var dialogue_label: Label = $DialogueLabel
@onready var textbox: Sprite2D = $HudNpcTextbox
@onready var pivot: Control = $Pivot


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func flip(cond : bool = false) -> void:
	if cond == true:
		pivot.scale.x = -1
		dialogue_label.position = Vector2(-341,-282)
	else:
		pivot.scale.x = 1
		dialogue_label.position = Vector2(75,-282)
	

func update_text(str : String) -> void:
	if str == "":
		return
	modulate.a = 1
	dialogue_label.text = str

extends Node2D

@export_file("*.tscn") var next_scene
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var skip_button: Button = %SkipButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.setup_button_audio(self)
	skip_button.pressed.connect(_on_skip_button_pressed)
	animation_player.animation_finished.connect(_on_anim_finish)
	animation_player.play("cutscene")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event:
		animation_player.stop()
		get_tree().change_scene_to_file(next_scene)

func _on_anim_finish(_anim_name : String) -> void:
	get_tree().change_scene_to_file(next_scene)


func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_file(next_scene)

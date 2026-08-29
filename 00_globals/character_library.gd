extends Node2D

var sprite_list : Array[Sprite2D]

func _ready() -> void:
	sprite_list = []
	
	for c in get_children():
		sprite_list.append(c)

func get_sprite(index : int = -1) -> Sprite2D:
	if index == -1:
		index = randi_range(0, sprite_list.size() - 1)
	
	return sprite_list[index]

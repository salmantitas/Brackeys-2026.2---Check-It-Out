class_name Blackboard
extends Resource

var can_decide : bool = true
var dir : float = 1.0

func update_distance_to_target ( pos : Vector2 ) -> void:
	pass
	#if target:
		#distance_to_target = pos.distance_to( target.global_position )
	#else:
		#distance_to_target = -1

func distance_to_x( pos : Vector2 ) -> float:
	return 0# abs(target.global_position.x - pos.x)
	
func distance_to_y( pos : Vector2 ) -> float:
	return 0#abs(target.global_position.y - pos.y)

extends Area2D
class_name VehicleCollider


var parent_speed: VehicleSpeed = null


func make_player() -> void: set_collision_mask_value(2, true)

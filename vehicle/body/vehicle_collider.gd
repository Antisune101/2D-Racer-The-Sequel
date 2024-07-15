extends Area2D
class_name VehicleCollider


var parent_speed: VehicleSpeed = null
var is_player: bool = false

func make_player() -> void:
	set_collision_mask_value(2, true)
	is_player = true


func _on_area_entered(_area: Area2D) -> void:
	if is_player: Globals.game_over.emit()

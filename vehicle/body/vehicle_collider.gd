extends Area2D
class_name VehicleCollider


@onready var parent: Vehicle = get_vehicle_parent(get_parent())


func get_vehicle_parent(_parent: Node) -> Vehicle:
	return _parent if _parent is Vehicle else get_vehicle_parent(_parent.get_parent())

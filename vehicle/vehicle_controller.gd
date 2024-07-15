extends Node
class_name VehicleController

@export_category("Dependencies")
@export var parent_vehicle: Vehicle
@export var vehicle_speed: VehicleSpeed
@export var steering_path: Path2D
@export var steer_anchor: PathFollow2D



func enable() -> void:
	pass


func disable() -> void:
	pass

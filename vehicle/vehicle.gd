extends PathFollow2D
class_name Vehicle


@onready var vehicle_speed: VehicleSpeed = $VehicleSpeed
@onready var steer_anchor: PathFollow2D = $VehicleSteering/SteerAnchor


func init_vehicle(vehicle_data: VehicleData) -> void:
	steer_anchor.add_child(vehicle_data.body.instantiate())

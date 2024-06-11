extends PathFollow2D
class_name Vehicle


@export var vehicle_speed: VehicleSpeed
@export var steer_anchor: PathFollow2D
@export var npc_controller: NPC_Controller


var body: VehicleBody = null

func init_vehicle(vehicle_data: VehicleData) -> void:
	body = vehicle_data.body.instantiate()
	body.parent = self
	steer_anchor.add_child(body)
	if npc_controller: npc_controller.init_npc(0.5, body.vehicle_detection)
	vehicle_speed.default_speed = vehicle_data.speed


func get_current_steer() -> float: return steer_anchor.progress_ratio


func get_nearest_lane() -> float:
	var current_steer = get_current_steer()
	if current_steer < .75 and current_steer > 0.25: return 0.5
	return 1.0 if current_steer > 0.75 else 0.0 

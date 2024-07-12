extends PathFollow2D
class_name Vehicle


@export var vehicle_speed: VehicleSpeed
@export var steer_anchor: PathFollow2D
@export var npc_controller: NPC_Controller
@export var vehicle_detection: VehicleDetection
@export var collision_avoidance: Area2D

var body: VehicleBody = null
var data: VehicleData
var steer: float

func init_vehicle(vehicle_data: VehicleData, init_steer: float) -> void:
	data = vehicle_data
	steer = init_steer

func _ready() -> void:
	body = data.body.instantiate()
	body.parent = self
	steer_anchor.add_child(body)
	body.set_color(randi_range(0, 6))
	if npc_controller:
		npc_controller.init_npc(.5)
		vehicle_detection.init_from_body(body)
		npc_controller.init_npc(steer)
		collision_avoidance.position = body.front_marker.position
	vehicle_speed.default_speed = data.speed


func _physics_process(_delta: float) -> void:
	if progress_ratio >= 0.8: queue_free()


func get_current_steer() -> float: return steer_anchor.progress_ratio


func get_nearest_lane() -> float:
	var current_steer = get_current_steer()
	if current_steer < .75 and current_steer > 0.25: return 0.5
	return 1.0 if current_steer > 0.75 else 0.0 

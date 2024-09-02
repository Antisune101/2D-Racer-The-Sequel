extends PathFollow2D
class_name Vehicle


static var player_vehicle: PlayerVehicle
static var player_vehicle_speed: VehicleSpeed
static var player_controller: PlayerController
static var player_vehicle_type: Globals.VehicleType


static var player_color: int = Globals.CarColors.WHITE:
	set(new_color):
		player_color = new_color
		Globals.player_color_updated.emit(new_color)


static var player_speed: float = 0.0:
	set(new_speed):
		player_speed = new_speed
		Globals.player_speed_updated.emit()


@export var vehicle_speed: VehicleSpeed
@export var steer_anchor: PathFollow2D
@export var npc_controller: NPC_Controller
@export var vehicle_detection: VehicleDetection
@export var collision_avoidance: Area2D


var body: VehicleBody = null
var data: VehicleData
var steer: float
var has_crashed: bool = false
var starting_speed: float = 0.0


func init_vehicle(vehicle_data: VehicleData, start_speed: float, init_steer: float) -> void:
	data = vehicle_data
	steer = init_steer
	starting_speed = start_speed

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
	vehicle_speed.default_speed = starting_speed
	body.collider.area_entered.connect(on_collision)


func on_collision(_area: Area2D) -> void:
	has_crashed = true
	vehicle_speed.speed = 0.0
	body.modulate = Color.BLACK


func _physics_process(_delta: float) -> void:
	if progress_ratio >= 0.8: queue_free()


func get_current_steer() -> float: return steer_anchor.progress_ratio


func get_nearest_lane() -> float:
	var current_steer = get_current_steer()
	if current_steer < .75 and current_steer > 0.25: return 0.5
	return 1.0 if current_steer > 0.75 else 0.0 

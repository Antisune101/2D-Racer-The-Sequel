extends VehicleController
class_name PlayerController
# TODO: Properly combine boost script with this
@export_category("Steering")
@export_range(0.0, 1.0) var initial_steer: float = 0.5
@export var steer_speed: float = 250.0
@export var steer_reset_force: float = 5.0
@export var lane_assist_max_steer: float = 0.2
@export var lane_assist_strength: float = 5


var steer: float = 0.0
@onready var max_steer_progress: float = steer_anchor.get_parent().curve.get_baked_length()


func enable() -> void:
	set_physics_process(true)


func disable() -> void:
	set_physics_process(false)


func _ready():
	parent_vehicle.init_vehicle(Player.vehicle_data)
	steer_anchor.progress_ratio = initial_steer


func _physics_process(delta: float) -> void:
	var input = Input.get_axis("steer_left", "steer_right")

	if input != 0.0: steer = input
	elif abs_steer() <= lane_assist_max_steer and not parent_vehicle.get_current_steer() in [0.0, 0.5, 1.0]:
		lane_assist(delta)
	
	if steer == 0.0: return 
	
	steer_anchor.progress += steer_speed * delta * steer
	steer = lerp(steer, 0.0, 1 - pow(0.5, steer_reset_force * delta))
	
	if abs_steer() > 0.0 and abs_steer() <= 0.1: steer = 0.0


func lane_assist(delta: float) -> void:
	steer_anchor.progress = lerp(steer_anchor.progress, max_steer_progress * parent_vehicle.get_nearest_lane(), 1 - pow(.5, lane_assist_strength * delta)) 


func abs_steer() -> float: return absf(steer)


#TODO: Fix braking

@export_category("Boost & Brake")
@export var boost_distance: float = 50.0
@export var boost_speed: float = 600
@export var boost_start_time: float = 1.25
@export var boost_stop_time: float = 1.5


var is_boosting: bool = false
var boost_tween: Tween = null


# TODO: Use boost amount instead of final boost value.
# This will make this variable redundant and possibly simplify code.
@onready var boost_amount: float = boost_speed - vehicle_speed.default_speed
@onready var parent = get_parent()
@onready var starting_position: float = get_parent().progress


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("boost") && !is_boosting: toggle_boost(true)
	elif event.is_action_released("boost") && is_boosting: toggle_boost(false)
	
	if event.is_action_pressed("brake") && !is_boosting:
		if boost_tween: boost_tween.kill()
		vehicle_speed.speed = 300
	if event.is_action_released("brake") && !is_boosting: vehicle_speed.speed = vehicle_speed.default_speed


func toggle_boost(should_boost: bool) -> void:
	is_boosting = should_boost
	if boost_tween: boost_tween.kill()
	boost_tween = create_tween().set_parallel(true)
	
	var anim_time: float
	var current_boost: float = vehicle_speed.speed - vehicle_speed.default_speed

	#Way too much math to find the right amount of time
	if is_boosting:
		anim_time = boost_start_time if  current_boost == 0.0 else boost_start_time * ( 1.0 - (current_boost / boost_amount))
	else:
		anim_time = boost_stop_time if current_boost == boost_amount else boost_stop_time * (current_boost  / boost_amount)
	
	
	var final_boost: float = starting_position-boost_distance if is_boosting else starting_position
	var final_speed: float = boost_speed if is_boosting else vehicle_speed.default_speed
	
	boost_tween.tween_property(parent, "progress", final_boost, anim_time)
	boost_tween.tween_property(vehicle_speed, "speed", final_speed, anim_time)

extends VehicleController
class_name PlayerController

@export_category("Steering")
@export_range(0.0, 1.0) var initial_steer: float = 0.5
@export var steer_speed: float = 250.0
@export var steer_reset_force: float = 5.0
@export var lane_assist_max_steer: float = 0.2
@export var lane_assist_strength: float = 5

@export_category("Speed Modifiers")
@export var reset_time: float = 0.75
#Boost
@export var boost_amount: float = 150.0
@export var boost_distance: float = 50.0
@export var boost_start_time: float = 1.25
#Brake
@export var brake_amount: float = 250.0
@export var brake_distance: float = 50.0
@export var brake_start_time: float = 1.25

var steer: float = 0.0
var is_boosting: bool = false
var anim_tween: Tween = null

@onready var max_steer_progress: float = steer_anchor.get_parent().curve.get_baked_length()
@onready var starting_position: float = get_parent().progress


func _ready():
	Player.player_controller = self
	parent_vehicle.init_vehicle(Player.vehicle_data, 0.5)
	steer_anchor.progress_ratio = initial_steer


func _physics_process(delta: float) -> void:
	if parent_vehicle.has_crashed:
		if anim_tween: anim_tween.kill()
		return
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


func _input(event: InputEvent) -> void:
	if parent_vehicle.has_crashed: return
	if event.is_action_pressed("boost"): animate_speed_modifier(boost_amount, boost_distance, boost_start_time)
	if event.is_action_pressed("brake"): animate_speed_modifier(-brake_amount, -brake_distance, brake_start_time)
	if event.is_action_released("boost") || event.is_action_released("brake"): animate_speed_modifier(-current_speed_modifier(), 0, reset_time, true)


func animate_speed_modifier(modifier: float, distance: float,  duration: float, reset: bool = false) -> void:
	if anim_tween: anim_tween.kill()
	anim_tween = create_tween().set_parallel(true)
	

	#Much less math to find the right time :)
	var anim_time: float = duration * (1 - (current_speed_modifier() / modifier))
	var final_pos: float = starting_position - distance
	var final_speed: float = vehicle_speed.default_speed + modifier if !reset else vehicle_speed.default_speed
	
	anim_tween.tween_property(parent_vehicle, "progress", final_pos, anim_time)
	anim_tween.tween_property(vehicle_speed, "speed", final_speed, anim_time)


func current_speed_modifier() -> float: return vehicle_speed.speed - vehicle_speed.default_speed

extends VehicleController
class_name NPC_Controller


@export var stay_centered: bool

var is_overtaking: bool = false

var speed_ahead: VehicleSpeed


func init_npc(init_steer: float) -> void:
	steer_anchor.progress_ratio = init_steer


func _physics_process(_delta: float) -> void:
	if is_overtaking: return
	var steer_int = get_current_steer_int()
	if !vehicle_detection.is_view_clear(steer_int) && vehicle_speed.is_faster_than(vehicle_detection.get_vehicle_in_view(steer_int).parent_speed):
		overtake()


func overtake() -> void:
	is_overtaking = true
	var target_lane = get_target_lane()
	if !target_lane == -1:
		await change_to_lane(float(target_lane)/2)
	is_overtaking = false


func change_to_lane(lane: float) -> void:
		await get_tree().create_tween().tween_property(steer_anchor, "progress_ratio", lane, 1.0).finished


func get_target_lane() -> int:
	var targets: Array[int] = vehicle_detection.get_passable_lanes()
	var steer_int = get_current_steer_int()
	for target in targets:
		# TL;DR Remove lane if not next to vehicle or not possible to turn to
		if (absi(steer_int - target) != 1) || (target > steer_int && !vehicle_detection.can_turn_right(steer_int)) || (target < steer_int && !vehicle_detection.can_turn_left(steer_int)): targets.erase(target)
	if targets.is_empty(): return -1
	return targets.pick_random()


func get_current_steer_int() -> float: return steer_anchor.progress_ratio * 2

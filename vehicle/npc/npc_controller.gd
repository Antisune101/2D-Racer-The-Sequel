extends VehicleController
class_name NPC_Controller


@export var stay_centered: bool
@export var vehicle_detection: VehicleDetection
@export var collision_avoidance: Area2D

var is_overtaking: bool = false

var speed_ahead: VehicleSpeed


func init_npc(init_steer: float) -> void:
	steer_anchor.progress_ratio = init_steer


func _physics_process(_delta: float) -> void:
	if collision_avoidance.has_overlapping_areas():
		var vehicle_ahead = collision_avoidance.get_overlapping_areas()[0] as VehicleCollider
		if vehicle_speed.is_faster_than(vehicle_ahead.parent_speed):
			vehicle_speed.speed = vehicle_ahead.parent_speed.speed
			
	elif vehicle_speed.speed != vehicle_speed.default_speed: vehicle_speed.speed = vehicle_speed.default_speed
	if is_overtaking: return
	var steer_int = get_current_steer_int()
	if !vehicle_detection: return
	if !vehicle_detection.is_view_clear(steer_int) && vehicle_speed.is_faster_than(vehicle_detection.get_vehicle_in_view(steer_int).parent_speed):
		overtake()


func overtake() -> void:
	is_overtaking = true
	var target_lane = get_target_lane()
	#print(target_lane)
	if !target_lane == -1:
		await change_to_lane(float(target_lane)/2)
	is_overtaking = false


func change_to_lane(lane: float) -> void:
		await get_tree().create_tween().tween_property(steer_anchor, "progress_ratio", lane, 0.75).finished


func get_target_lane() -> int:
	var targets: Array[int] = vehicle_detection.get_passable_lanes()
	var steer_int = get_current_steer_int()
	for target in targets:
		#print("%s eval" % target)
		# TL;DR Remove lane if not next to vehicle or not possible to turn to
		if absi(steer_int - target) != 1:
			targets.erase(target)
			if !targets.has(1):
				targets.append(1)
				target = 1
			else: continue
		if (target > steer_int && !vehicle_detection.can_turn_right(steer_int)) || (target < steer_int && !vehicle_detection.can_turn_left(steer_int)): targets.erase(target)
	if targets.is_empty(): return -1
	return targets.pick_random()


func get_current_steer_int() -> float: return steer_anchor.progress_ratio * 2

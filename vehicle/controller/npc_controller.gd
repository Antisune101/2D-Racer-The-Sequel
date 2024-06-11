extends VehicleController
class_name NPC_Controller


@export var stay_centered: bool

var target_steer: float
var is_overtaking: bool = false
var is_turning: bool = false
var speed_ahead: VehicleSpeed

var vehicle_detection: VehicleDetection = null


func init_npc(init_steer: float, init_vehicle_detection: VehicleDetection) -> void:
	steer_anchor.progress_ratio = init_steer
	vehicle_detection = init_vehicle_detection
	vehicle_detection.collision.area_entered.connect(_on_front_detection_entered)
	vehicle_detection.collision.area_exited.connect(_on_front_detection_left)


func _physics_process(_delta: float):
	if is_overtaking: 
		if !is_turning: try_overtake()
	elif !vehicle_detection.is_view_clear() && is_faster_than(vehicle_detection.get_vehicle_in_view().parent_speed):
		get_target_steer()
		is_overtaking = true
	print(vehicle_detection.is_view_clear() if vehicle_detection.is_view_clear() else "I see you %s" %  is_faster_than(vehicle_detection.get_vehicle_in_view().parent_speed))


func try_overtake() -> void:
	if (target_steer < steer_anchor.progress_ratio and vehicle_detection.is_left_clear()) or ( target_steer > steer_anchor.progress_ratio and vehicle_detection.is_right_clear()):
		is_turning = true
		await get_tree().create_tween().tween_property(steer_anchor, "progress_ratio", target_steer, 1.0).finished
		is_overtaking = false
		is_turning = false
		
	else: get_target_steer()


func get_target_steer() -> void:
	var possible_steer: Array[float] = []
	var current_steer := steer_anchor.progress_ratio
	
	if vehicle_detection.can_pass_left():
		possible_steer.append(current_steer - 0.5)
	if vehicle_detection.can_pass_right():
		possible_steer.append(current_steer + 0.5)
	if possible_steer.is_empty(): return
	
	target_steer = possible_steer.pick_random()


func is_faster_than(speed: VehicleSpeed) -> bool: return vehicle_speed.speed > speed.speed


func adjust_speed() -> void:
	if speed_ahead == null: if vehicle_speed.speed != vehicle_speed.default_speed: vehicle_speed.speed = vehicle_speed.default_speed
	elif is_faster_than(speed_ahead):
		vehicle_speed.speed = speed_ahead.speed


func _on_front_detection_entered(collider: VehicleCollider) -> void:
	speed_ahead = collider.parent_speed
	speed_ahead.speed_updated.connect(adjust_speed)
	if is_faster_than(speed_ahead): adjust_speed()


func _on_front_detection_left(_vehicle: VehicleCollider) -> void:
	speed_ahead.speed_updated.disconnect(adjust_speed)
	await get_tree().create_timer(0.01).timeout
	speed_ahead = null
	adjust_speed()

extends Node
class_name VehicleVisibilityManager

@export var movement_path: Path2D


var prev_state: Dictionary = {}


# :) This is much better than the old system. Could propably be optimized further
func _physics_process(_delta: float) -> void:
	var lanes: Dictionary = { 0.0: [], 0.5: [], 1.0: [] }
	
	for vehicle: Vehicle in movement_path.get_children(): lanes[vehicle.get_nearest_lane()].append(vehicle)
	
	if lanes == prev_state: return
	
	var vehicle_z_index: int = 1
	
	for lane in lanes.keys():
		lanes[lane].sort_custom(func(a: Vehicle, b: Vehicle): return a.progress < b.progress)
		
		for vehicle: Vehicle in lanes[lane]:
			vehicle.z_index = vehicle_z_index
			vehicle_z_index += 1
	
	prev_state = lanes

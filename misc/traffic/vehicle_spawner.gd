#NOTE: This algorithm thing will propably rival Google's search engine in complexity
#It has no reason to :(
extends Node
class_name VehicleSpawner

@export var vehicle_scene: PackedScene
@export var vehicle_database: VehicleDatabase
@export var movement_path: Path2D


var is_wave: bool = false


var prev_segment: TrafficSegment = TrafficSegment.new(true)

var distance_past: float
var has_segment_past: bool = false


func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_page_up"): on_segment_past()
	if !has_segment_past:
		distance_past += (Player.player_speed - Globals.get_vehicle_data_from_id("car").speed) * delta
	
		if distance_past >= prev_segment.size:
			has_segment_past = true
			distance_past = 0.0
			on_segment_past()

func on_segment_past() -> void:
	var new_segment = generate_next_segment()
	
	spawn_segment(new_segment)
	
	prev_segment = new_segment
	has_segment_past = false


func generate_next_segment() -> TrafficSegment:
	print("generating new segment...")
	var current_segment = TrafficSegment.new(false)
	
	is_wave = !is_wave
	var empty_lane_target: int = randi_range(1, 2) if is_wave else randi_range(2, 3)
	
	for i in range(24):
		if current_segment.all_lanes_collapsed():
			break
		collapse_lane(current_segment, empty_lane_target)
	#Failsafe
	if !current_segment.all_lanes_collapsed():
		print("Failed")
		for lane in current_segment.get_uncollapsed_lanes(): current_segment.collapse_to_empty(lane)
	print(current_segment.lane_data)
	return current_segment


func collapse_lane(current_segment: TrafficSegment, empty_lane_target: int = 1) -> void:
	var uncollapsed_lanes = current_segment.get_uncollapsed_lanes()
	
	#If we reach the empty target, collapse the remaining lanes to empty
	if current_segment.id_count("empty") <= empty_lane_target:
		for lane in uncollapsed_lanes: current_segment.collapse_to_empty(lane)
		return
	
	#Make sure the player can pass through if there is only one open lane
	if prev_segment.id_count("empty") == 1:
		var empty_lane: int = prev_segment.get_empty_lanes()[0]
		if uncollapsed_lanes.has(empty_lane):
			current_segment.collapse_to_empty(empty_lane)
			return
	
	
	#This should avoid player getting 'caged' in
	if !prev_segment.is_lane_empty(1) &&  (uncollapsed_lanes.has(0) || uncollapsed_lanes.has(2)):
		if uncollapsed_lanes.has(0): current_segment.lane_data[0].erase("car")
		if uncollapsed_lanes.has(2): current_segment.lane_data[2].erase("car")
		
		return
	
	# Only spawn a truck if there is more than one open lane
	if prev_segment.id_count("empty") == 1:
		for lane in uncollapsed_lanes:
			current_segment.lane_data[lane].erase("truck")
		return
	
	# Make sure only one truck spawns per segment
	if current_segment.id_count_collapsed("truck") != 0:
		for lane in uncollapsed_lanes:
			current_segment.lane_data[lane].erase("truck")
		return
	

	#Randomly collapse a lane, if no rules apply
	current_segment.collapse_to_random(uncollapsed_lanes.pick_random())


func spawn_segment(segment: TrafficSegment) -> void:
	if !segment.lane_data[0].has("empty"):
		spawn_vehicle(Globals.get_vehicle_data_from_id(segment.lane_data[0][0]), 0.0)
	if !segment.lane_data[1].has("empty"):
		spawn_vehicle(Globals.get_vehicle_data_from_id(segment.lane_data[1][0]), 0.5)
	if !segment.lane_data[2].has("empty"):
		spawn_vehicle(Globals.get_vehicle_data_from_id(segment.lane_data[2][0]), 1.0)


func spawn_vehicle(data: VehicleData, lane: float) -> void:
	var new_vehicle: Vehicle = vehicle_scene.instantiate()
	movement_path.add_child(new_vehicle)
	new_vehicle.init_vehicle(data, lane)

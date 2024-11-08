#NOTE: This algorithm thing will propably rival Google's search engine in complexity
#It has no reason to :(
extends Node
class_name VehicleSpawner

@export var is_active: bool = true
@export var vehicle_scene: PackedScene
@export var vehicle_database: VehicleDatabase
@export var movement_path: Path2D
@export var segment_size_max: float = 300
@export var segment_size_min: float = 175


var distance_past: float
var has_segment_past: bool = false
var segment_gen: SegmentGenerator = SegmentGenerator.new()
var segment_size: float = 500.0
var current_segment: Dictionary = {
	"is_finished": false
}


func _enter_tree() -> void:
	if !is_active: queue_free()

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_page_up"): on_segment_past()
	if !has_segment_past:
		distance_past += (Vehicle.player_speed - VehicleData.NPC_SPEED) * delta
		
		
		for i in range(3):
			if !current_segment["is_finished"]: break
			if current_segment[i]["char"] != "E" && distance_past >= current_segment[i]["offset"] && !current_segment[i]["has_spawned"]:
				spawn_vehicle(Globals.get_vehicle_data_by_type(Globals.VehicleType.CAR if current_segment[i]["char"] == "C" else Globals.VehicleType.TRUCK), i/2.0)
				current_segment[i]["has_spawned"] = true
		
		if distance_past >= segment_size:
			has_segment_past = true
			on_segment_past()


func on_segment_past() -> void:
	spawn_segment(segment_gen.get_next_segment())
	distance_past = 0.0
	has_segment_past = false


func spawn_segment(new_segment: String) -> void:
	segment_size = randf_range(segment_size_min, segment_size_max)
	var offsets: Array[float] = get_random_offsets()
	current_segment = {
		"is_finished": false,
		0:{},
		1:{},
		2:{}
	}
	for i in range(3):
		current_segment[i]["offset"] = offsets[i]
		current_segment[i]["char"] = new_segment[i]
		current_segment[i]["has_spawned"] = false
	current_segment["is_finished"] = true


func spawn_vehicle(data: VehicleData, lane: float) -> void:
	var new_vehicle: Vehicle = vehicle_scene.instantiate()
	new_vehicle.init_vehicle(data, VehicleData.NPC_SPEED, lane)
	movement_path.add_child(new_vehicle)


func get_random_offsets() -> Array[float]:
	var arr: Array[float] = []
	var max_offset: float = segment_size - segment_size_min
	for i in range(3): arr.append(randf_range(0, max_offset))
	return arr

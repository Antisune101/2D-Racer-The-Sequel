extends Node
class_name TrafficSegment


const min_size: float = 175
const max_size: float = 225

var size: float = 0.0


var lane_data: Dictionary = {
	0: ["empty", "car", "truck"],
	1: ["empty", "car", "truck"],
	2: ["empty", "car", "truck"],
}


func _init(is_empty: bool) -> void:
	if is_empty: lane_data = { 0:["empty"], 1:["empty"], 2:["empty"] }
	size = randf_range(min_size, max_size)

func all_lanes_collapsed() -> bool:
	for lane in lane_data.keys(): if lane_data[lane].size() > 1: return false
	return true


#NOTE: Why do I need this? I think it may be redundent
func collapsed_lane_count() -> int:
	var count: int = 0
	for lane in lane_data.keys(): if lane_data[lane].size() == 1: count += 1
	return count


func get_collapsed_lanes() -> Array[int]:
	var arr: Array[int] = []
	for lane in lane_data.keys(): if lane_data[lane].size() == 1: arr.append(lane)
	return arr


func get_uncollapsed_lanes() -> Array[int]:
	var arr: Array[int] = []
	for lane in lane_data.keys(): if lane_data[lane].size() > 1: arr.append(lane)
	return arr


func get_empty_lanes() -> Array[int]:
	var arr: Array[int] = []
	for lane in lane_data.keys(): if is_lane_empty(lane): arr.append(lane)
	return arr


func id_count(id: String) -> int:
	var count: int = 0
	for lane in lane_data.keys(): if lane_data[lane].has(id): count += 1
	return count


func id_count_collapsed(id: String) -> int:
	var count: int = 0
	for lane in get_uncollapsed_lanes(): if lane_data[lane].has(id): count += 1
	return count


func collapse_to_empty(lane_id: int) -> void:
	print("%s collapsed to empty" % lane_id)
	lane_data[lane_id] = [ "empty" ]


func collapse_to_random(lane_id: int) -> void:
	lane_data[lane_id].erase("empty")
	lane_data[lane_id] = [ lane_data[lane_id].pick_random() ]
	print("%s randomly collapsed to %s" % [lane_id, lane_data[lane_id] ])


func is_lane_empty(lane_id: int) -> bool: return lane_data[lane_id] == [ "empty" ]

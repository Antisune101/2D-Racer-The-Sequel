extends Node
class_name SegmentGenerator


const POSSIBLE_SEGMENTS: Array[String] = [
	"EEE",
	"CEE",
	"ECE",
	"EEC",
	"CCE",
	"ECC",
	"CEC",
]

const SEGMENT_CACHE_SIZE: int = 3


var segment_cache: Array[String] = []
var prev_segment: String = "EEE"
var player_pos: String = "EEE"


func get_next_segment() -> String:
	var next_segment = find_possible_segments().pick_random()
	segment_cache.append(next_segment)
	if segment_cache.size() > SEGMENT_CACHE_SIZE: segment_cache.pop_front()
	print(segment_cache)
	player_pos = get_player_pos(next_segment)
	prev_segment = next_segment
	return next_segment


func find_possible_segments() -> Array[String]:
	var possibles: Array[String] = get_connecting_empty(player_pos)
	
	
	for possible in possibles:
		#NOTE: Put all the rules for traffic gen here
		
		if (possible == "ECE" and player_pos == "EEE") or (possible in segment_cache and randf_range(0.0, 1.0) >= .1):
			possibles.erase(possible)
	#NOTE: Ternary statements are awesome <3
	return possibles if !possibles.is_empty() else ["EEE"]


func get_connecting_empty(segment: String) -> Array[String]:
	var arr: Array[String] = []
	for seg in POSSIBLE_SEGMENTS:
		if has_connecting_empty(seg, segment): arr.append(seg)
	return arr


func get_empty_positions(segment: String) -> Array[int]:
	var arr: Array[int] = []
	for i in range(segment.length()):
		if segment[i] == "E":
			arr.append(i)
	return arr


func has_connecting_empty(segment_1: String, segment_2: String) -> bool:
	var positions_1: Array[int] = get_empty_positions(segment_1)
	var positions_2: Array[int] = get_empty_positions(segment_2)
	for i in positions_1:
		if i in positions_2:
			return true
	return false


func get_player_pos(new_segment: String) -> String:
	var pos: String = "CCC"
	if new_segment == "ECE":
		if player_pos[0] == "E" and player_pos[2] == "E":
			pos = "ECC" if randi_range(0, 1) else "CCE"
		else: pos = "ECC" if player_pos[0] == "E" else "CCE"
	else: pos = new_segment
	return pos

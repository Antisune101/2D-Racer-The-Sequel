extends Node2D
class_name VehicleDetection


@export var detection_offset: Vector2 = Vector2(8, 4)


@onready var front: Node2D = $Front
@onready var side: Node2D = $Side
@onready var rear: Node2D = $Rear


@onready var front_lanes: Array[Area2D] = get_lane_areas(front)
@onready var side_lanes: Array[Area2D] = get_lane_areas(side)
@onready var rear_lanes: Array[Area2D] = get_lane_areas(rear)


func init_from_body(body: VehicleBody) -> void:
	rear.global_position = body.rear_marker.global_position + Vector2(-detection_offset.x, detection_offset.y)
	side.global_position = body.rear_marker.global_position
	front.global_position = body.front_marker.global_position + Vector2(detection_offset.x, -detection_offset.y)
	
	var distance: Vector2 = body.front_marker.position - body.rear_marker.position
	
	for polygon in get_side_polygons():
		polygon.polygon[1] = distance + polygon.polygon[0]
		polygon.polygon[2] = distance + polygon.polygon[3]


func get_lane_areas(parent_node: Node2D) -> Array[Area2D]:
	var arr: Array[Area2D] = []
	for lane: Area2D in parent_node.get_children(): arr.append(lane)
	return arr

func get_side_polygons() -> Array[CollisionPolygon2D]:
	var arr: Array[CollisionPolygon2D] = []
	for area in side_lanes: arr.append(area.get_child(0))
	return arr


func is_view_clear(lane_id: int) -> bool: return !front_lanes[lane_id].has_overlapping_areas()


func get_vehicle_in_view(lane_id: int) -> VehicleCollider: return front_lanes[lane_id].get_overlapping_areas()[0]


func can_turn_left(current_lane: int) -> bool:
	var left = current_lane - 1
	if left < 0: return false
	return !side_lanes[left].has_overlapping_areas() && !rear_lanes[left].has_overlapping_areas()


func can_turn_right(current_lane: int) -> bool:
	var right = current_lane + 1
	
	if right > 2: return false
	return !side_lanes[right].has_overlapping_areas() && !rear_lanes[right].has_overlapping_areas()



func get_passable_lanes() -> Array[int]:
	var arr: Array[int] = []
	for lane in front_lanes:
		if !lane.has_overlapping_areas(): arr.append(front_lanes.find(lane))
	return arr

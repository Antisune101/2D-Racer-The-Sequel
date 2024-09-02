extends Node2D
class_name Road

@export var intersection_chance: float


var road_segments: Array[RoadSegment] = []


func _ready() -> void:
	for segment: RoadSegment in $MovementPath.get_children(): road_segments.append(segment)
	for segment: RoadSegment in road_segments: segment.looped.connect(_generate_new_road_segment)


func _physics_process(delta: float) -> void:
	for segment: RoadSegment in road_segments: segment.progress += Vehicle.player_speed * delta


func _generate_new_road_segment(segment: RoadSegment) -> void:
	segment.road_sprite.frame = 0 if randf_range(0.0, 1.0) > intersection_chance else 1

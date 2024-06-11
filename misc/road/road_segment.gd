extends PathFollow2D
class_name RoadSegment

signal looped(road_segment: RoadSegment)


var prev_ratio: float = 0.0


@onready var road_sprite: Sprite2D = $Sprite2D


func _process(_delta: float) -> void:
	if progress_ratio < prev_ratio: looped.emit(self)
	prev_ratio = progress_ratio

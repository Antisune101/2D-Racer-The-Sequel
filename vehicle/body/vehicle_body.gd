extends Node2D
class_name VehicleBody


@onready var vehicle_detection: VehicleDetection = $VehicleDetection
@onready var sprite: Sprite2D = $VehicleSprite

var parent: Vehicle


func _ready() -> void: $VehicleCollider.parent_speed = parent.vehicle_speed


func set_color(color_id: int = 0) -> void:
	sprite.frame = color_id

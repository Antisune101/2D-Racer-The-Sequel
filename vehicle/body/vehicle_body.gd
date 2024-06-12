extends Node2D
class_name VehicleBody


@onready var sprite: Sprite2D = $VehicleSprite
@onready var collider: VehicleCollider = $VehicleCollider

@onready var front_marker: Marker2D = $Front
@onready var rear_marker: Marker2D = $Rear


var parent: Vehicle


func _ready() -> void: $VehicleCollider.parent_speed = parent.vehicle_speed


func set_color(color_id: int = 0) -> void:
	sprite.frame = color_id

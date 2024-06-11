extends Node2D
class_name VehicleBody


@onready var vehicle_detection: VehicleDetection = $VehicleDetection


var parent: Vehicle


func _ready() -> void: $VehicleCollider.parent_speed = parent.vehicle_speed

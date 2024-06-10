extends Node2D
class_name VehicleDetection


@export var view: Area2D
@export var collision: Area2D
@export var front_left: Area2D
@export var front_right: Area2D
@export var left: Area2D
@export var right: Area2D
@export var rear_left: Area2D
@export var rear_right: Area2D


func is_view_clear() -> bool: return !view.has_overlapping_areas()


func get_vehicle_in_view() -> VehicleCollider: return view.get_overlapping_areas()[0]


func will_collide() -> bool: return !collision.has_overlapping_areas()


func can_pass_left() -> bool: return !front_left.has_overlapping_areas()


func can_pass_right() -> bool: return !front_right.has_overlapping_areas()


func is_left_clear() -> bool: return !left.has_overlapping_areas() && !rear_left.has_overlapping_areas()


func is_right_clear() -> bool: return !right.has_overlapping_areas() && !rear_right.has_overlapping_areas()

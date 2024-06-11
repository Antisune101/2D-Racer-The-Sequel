extends Node
class_name VehicleSpawner

@export var vehicle_scene: PackedScene
@export var vehicle_database: VehicleDatabase
@export var movement_path: Path2D


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		spawn_vehicle()


func spawn_vehicle() -> void:
	var new_vehicle: Vehicle = vehicle_scene.instantiate()
	movement_path.add_child(new_vehicle)
	new_vehicle.init_vehicle(vehicle_database.data.pick_random())

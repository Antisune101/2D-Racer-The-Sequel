extends Node

signal change_to_menu(target_menu)
signal goto_prev_menu
signal game_over

enum CAR_COLORS {
	RED,
	ORANGE,
	GREEN,
	BLUE,
	PURPLE,
	WHITE,
	BLACK
}

var vehicle_database: VehicleDatabase = load("res://vehicle/data/database.tres")

func get_vehicle_data_from_id(id: String) -> VehicleData:
	for vehicle: VehicleData in vehicle_database.data:
		if vehicle.id == id: return vehicle
	return null

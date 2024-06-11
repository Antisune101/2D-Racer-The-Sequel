extends Node

signal change_to_menu(target_menu)


enum CAR_COLORS {
	RED,
	ORANGE,
	GREEN,
	BLUE,
	PURPLE,
	WHITE,
	BLACK
}

var vehicle_database: VehicleDatabase = preload("res://vehicle/data/database.tres")

extends Node

signal change_to_menu(target_menu)
signal goto_prev_menu
signal game_over
signal player_speed_updated
signal player_color_updated(new_color: int)
signal reload_menu_cursor
signal osk_letter_input(letter: String)

# Signals related to the on screen keyboard or O.S.K for short
signal osk_delete_input
signal osk_space_input
signal osk_enter_input

enum CarColors {
	RED,
	ORANGE,
	GREEN,
	BLUE,
	PURPLE,
	WHITE,
	BLACK,
}

enum VehicleType {
	CAR,
	TRUCK,
	TONK,
	PICKUP,
	VAN,
	STATION_WAGON
}

var score: int = 0
var player_name: String = ""
var player_name_limit: int = 12

var vehicle_database: VehicleDatabase = load("res://vehicle/data/database.tres")


func _ready() -> void:
	var path: String = "res://silent_wolf_api.env"
	if !FileAccess.file_exists(path):
		push_warning("No env file found. Leaderboard unavailable")
		push_warning("If you want acces to leaderboard visit https://silentwolf.com/ for more info")
		return
		
	var file = FileAccess.open(path, FileAccess.READ)
	var api_key = file.get_line()
	SilentWolf.configure({
		"api_key": api_key,
		"game_id": "cargame",
		"log_level": 1
	})


func get_vehicle_data_by_type(type: VehicleType) -> VehicleData:
	for vehicle: VehicleData in vehicle_database.data:
		if vehicle.type == type: return vehicle
	return null

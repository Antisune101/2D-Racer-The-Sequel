# A way to give a global refrence to player stats/variables
extends Node

signal player_speed_updated
signal player_color_updated(new_color: int)


const starting_pos: float = 0.56
const starting_speed: float = 800.0

@onready var vehicle_data = Globals.vehicle_database.data[0].duplicate(true)


var player_vehicle: PlayerVehicle
var player_vehicle_speed: VehicleSpeed
var player_controller: PlayerController

func _ready() -> void:
	vehicle_data.speed = starting_speed


@onready var player_color: int = Globals.CAR_COLORS.WHITE:
	set(new_color):
		player_color = new_color
		player_color_updated.emit(new_color)


var player_speed: float = 0.0:
	set(new_speed):
		player_speed = new_speed
		player_speed_updated.emit()

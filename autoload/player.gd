# A way to give a global refrence to player stats/variables
extends Node

signal player_speed_updated


var player_speed: float = 0.0:
	set(new_speed):
		player_speed = new_speed
		player_speed_updated.emit()
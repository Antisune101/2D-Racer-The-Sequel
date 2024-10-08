extends Node
class_name VehicleSpeed

signal speed_updated


var default_speed: float = 0.0:
	set(new_default_speed):
		if speed == 0.0: speed = new_default_speed
		default_speed = new_default_speed


var speed: float = 0.0:
	set(new_speed):
		if parent.has_crashed:
			if speed != 0.0:
				speed = 0.0
				if is_player: Vehicle.player_speed = 0.0
			return
		speed = new_speed
		if is_player: Vehicle.player_speed = new_speed
		speed_updated.emit()


@onready var parent: PathFollow2D = get_parent()
@onready var is_player: bool = parent.is_in_group("player")


# Disable _physics_process if vehicle is the 'player'
func _ready() -> void:
	if is_player:
		set_physics_process(false)
		Vehicle.player_vehicle_speed = self

# Move vehicle relative to 'player' speed
func _physics_process(delta: float) -> void: parent.progress += (Vehicle.player_speed - speed) * delta



func is_faster_than(other_speed: VehicleSpeed) -> bool: return speed > other_speed.speed

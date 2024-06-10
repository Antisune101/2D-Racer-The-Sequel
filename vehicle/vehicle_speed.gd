extends Node
class_name VehicleSpeed

signal speed_updated


var default_speed: float = 0.0:
	set(new_default_speed): if speed == 0.0: speed = new_default_speed


var speed: float = 0.0:
	set(new_speed):
		speed = new_speed
		if is_player: Player.player_speed = new_speed
		speed_updated.emit()


@onready var parent: PathFollow2D = get_parent()
@onready var is_player: bool = parent.is_in_group("player")


# Disable _physics_process if vehicle is the 'player'
func _ready() -> void: if is_player: set_physics_process(false)


# Move vehicle relative to 'player' speed
func _physics_process(delta: float) -> void: parent.progress_ratio += (Player.player_speed - speed) * delta

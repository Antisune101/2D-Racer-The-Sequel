extends Vehicle
class_name PlayerVehicle


@export var use_npc_controller: bool

func _ready() -> void:
	Player.player_vehicle = self
	super._ready()
	body.set_color(Player.player_color)
	body.collider.make_player()
	Player.player_color_updated.connect(body.set_color)
	
	if use_npc_controller:
		$PlayerController.queue_free()
	else:
		$NPC_Controller.queue_free()
		$VehicleDetection.queue_free()
		$VehicleSteering/SteerAnchor/CollisionAvoidance.queue_free()
	progress_ratio = Player.starting_pos

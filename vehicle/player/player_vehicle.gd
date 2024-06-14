extends Vehicle
class_name PlayerVehicle


@export var use_npc_controller: bool


func _ready() -> void:
	body.set_color(Player.player_color)
	body.collider.make_player()
	Player.player_color_updated.connect(body.set_color)
	
	if use_npc_controller:
		progress_ratio = Player.npc_pos
		$PlayerController.queue_free()
	else:
		progress_ratio = Player.starting_pos
		$NPC_Controller.queue_free()
		$VehicleDetection.queue_free()
		$VehicleSteering/SteerAnchor/CollisionAvoidance.queue_free()

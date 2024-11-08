extends Vehicle
class_name PlayerVehicle


@export var use_npc_controller: bool


func _enter_tree() -> void:
	if Vehicle.player_vehicle:
		Vehicle.player_vehicle.queue_free()
	Vehicle.player_vehicle = self


func _exit_tree() -> void:
	if Vehicle.player_vehicle == self:
		Vehicle.player_vehicle = null


func _ready() -> void:
	Vehicle.movement_path = get_parent()
	super._ready()
	body.set_color(Vehicle.player_color)
	body.collider.make_player()
	Globals.player_color_updated.connect(body.set_color)
	
	if use_npc_controller:
		$PlayerController.queue_free()
	else:
		$NPC_Controller.queue_free()
		$VehicleDetection.queue_free()
		$VehicleSteering/SteerAnchor/CollisionAvoidance.queue_free()
	progress_ratio = VehicleData.PLAYER_STARTING_POS

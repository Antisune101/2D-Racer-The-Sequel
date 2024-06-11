extends Vehicle
class_name PlayerVehicle


@export var use_npc_controller: bool


func _ready() -> void:
	if use_npc_controller: $PlayerController.queue_free()
	else: $NPC_Controller.queue_free()

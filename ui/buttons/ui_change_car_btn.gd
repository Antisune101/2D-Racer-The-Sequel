class_name UIChangeCarBtn extends UIButton


var btn_type: Globals.VehicleType
var is_selected: bool = false


func _init(type: Globals.VehicleType) -> void:
	btn_type = type
	text = Globals.get_vehicle_data_by_type(type).display_name


func _physics_process(_delta: float) -> void:
	if is_selected && scale != Vector2(1.1, 1.1):
		hover()


func select() -> void:
	if Vehicle.player_vehicle_type == btn_type: return
	
	Vehicle.player_vehicle_type = btn_type
	await SceneManager.cover_screen()
	Vehicle.player_vehicle.queue_free()
	Vehicle.movement_path.add_child(Vehicle.PLAYER_SCENE.instantiate())
	SceneManager.show_screen()

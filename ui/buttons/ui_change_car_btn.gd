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
	Vehicle.player_vehicle_type = btn_type
	SceneManager.reload_scene()

class_name GenerateColors extends VBoxContainer

@onready var back_btn: UIBackBtn = get_children()[0] as UIBackBtn

func _ready() -> void:
	for car in Globals.VehicleType.values():
		if car == Globals.VehicleType.TRUCK:
			continue
		add_child(UIChangeCarBtn.new(car))
	move_child(back_btn, -1)

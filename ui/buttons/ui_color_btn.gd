extends UIButton
class_name UIColorBtn


var btn_color: Globals.CarColors


var btn_text: String
var is_selected: bool = false

@onready var selected_text: String = "[ %s ]" % btn_text


func _init(color: Globals.CarColors) -> void:
	btn_text = Globals.CarColors.keys()[color]
	btn_color = color
	


func _ready() -> void:
	Globals.player_color_updated.connect(player_color_changed)
	player_color_changed(Vehicle.player_color)


func _physics_process(_delta: float) -> void:
	if is_selected && scale != Vector2(1.1, 1.1):
		hover()


func select() -> void:
	Vehicle.player_color = btn_color


func player_color_changed(new_color: int) -> void:
	is_selected = new_color == btn_color
	
	if is_selected:
		text = selected_text
	else:
		text = btn_text

extends UIButton
class_name UIColorBtn


@export var btn_color: Globals.CAR_COLORS


@onready var btn_text: String = text
@onready var selected_text: String = "[ %s ]" % btn_text


var is_selected: bool = false


func _ready() -> void:
	Player.player_color_updated.connect(player_color_changed)
	player_color_changed(Player.player_color)


func _physics_process(delta: float) -> void:
	if is_selected && scale != Vector2(1.1, 1.1):
		hover()


func select() -> void:
	Player.player_color = btn_color


func player_color_changed(new_color: int) -> void:
	is_selected = new_color == btn_color
	
	if is_selected:
		text = selected_text
	else:
		text = btn_text

extends UIButton
class_name UIColorBtn


@export var btn_color: Globals.CAR_COLORS


@onready var btn_text: String = text
@onready var selected_text: String = "[ %s ]" % btn_text


func _ready() -> void:
	Player.player_color_updated.connect(player_color_changed)
	player_color_changed(Player.player_color)


func select() -> void:
	Player.player_color = btn_color


func player_color_changed(new_color: int) -> void:
	text = selected_text if new_color == btn_color else btn_text

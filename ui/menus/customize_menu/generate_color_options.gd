class_name GenerateColorOptions extends VBoxContainer


@onready var back_btn: UIBackBtn = get_children()[0] as UIBackBtn

func _ready() -> void:
	for color in Globals.CarColors.values():
		add_child(UIColorBtn.new(color))
	move_child(back_btn, -1)

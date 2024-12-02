extends Control
class_name UIMenu



@export var is_grid: bool = false
@export var btn_list_path: NodePath
@export var btn_grid_path: NodePath


@onready var buttons: Control = get_node(btn_list_path if !is_grid else btn_grid_path)


func _ready() -> void:
	if is_grid:
		buttons = get_node(btn_grid_path)
		get_node(btn_list_path).queue_free()
	else:
		buttons = get_node(btn_list_path)
		get_node(btn_grid_path).queue_free()

func show_menu() -> void: visible = true


func hide_menu() -> void: visible = false

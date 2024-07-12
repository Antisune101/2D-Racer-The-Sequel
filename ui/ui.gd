extends Control
class_name UI


@export var starting_menu: UIMenu


var current_menu: UIMenu
var menu_stack: Array[UIMenu] = []

@onready var menu_cursor: UIMenuCursor = $UIMenuCursor
@onready var menus: Array[UIMenu] = get_menus()


func _ready() -> void:
	Globals.change_to_menu.connect(switch_to_menu)
	Globals.goto_prev_menu.connect(goto_prev_menu)
	
	for menu in menus: menu.hide_menu()
	
	if starting_menu: switch_to_menu(starting_menu)
	else: push_warning("UI Warning: No starting_menu assigned")


func goto_prev_menu() -> void:
	if menu_stack.size() == 1: return
	var prev_menu: UIMenu = menu_stack[-1]
	menu_stack.erase(prev_menu)
	show_menu(prev_menu)


func get_menus() -> Array[UIMenu]:
	var arr: Array[UIMenu] = []
	for menu: UIMenu in $CenteredMenus.get_children() + $UncenteredMenus.get_children(): arr.append(menu)
	return arr


func switch_to_menu(menu: UIMenu) -> void:
	menu_stack.append(current_menu)
	show_menu(menu)


func show_menu(new_menu: Control) -> void:
	if current_menu: current_menu.hide_menu()
	
	menu_cursor.switch_to_menu(new_menu)
	
	new_menu.show_menu()
	
	current_menu = new_menu

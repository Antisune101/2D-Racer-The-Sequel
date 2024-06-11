extends UIButton
class_name UISwitchMenuBtn


@export var target_menu: UIMenu

# NOTE: This should make sure switch_menu_btn's always have a target_menu assigned
func _ready() -> void: if !target_menu: push_warning("UI Warning: target_menu not assigned")


func select() -> void: Globals.change_to_menu.emit(target_menu)

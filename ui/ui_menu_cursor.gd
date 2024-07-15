extends Label
class_name UIMenuCursor

var menu_parent: Control = null
var menu_index: int = 0

var just_visible: bool = false


func _init() -> void:
	text = ">"


func _physics_process(_delta: float) -> void:
	if !visible: return
	
	if just_visible:
		just_visible = false
		return
	
	if Input.is_action_just_pressed("ui_select"):
		var menu_item = get_menu_item_at_index(menu_index)
		if menu_item != null:
			menu_item.select()
			SoundManager.play_sound("select")
	
	var input: int = 0
	if Input.is_action_just_pressed("ui_up"): input -= 1
	if Input.is_action_just_pressed("ui_down"): input += 1
	
	
	if input == 0: return
	
	var new_index = menu_index + input
	
	if new_index > menu_parent.get_child_count() - 1: new_index = 0
	elif new_index < 0: new_index = menu_parent.get_child_count() - 1
	set_cursor_from_index(new_index, menu_index)
	menu_index = new_index
	SoundManager.play_sound("move_cursor")
	

func _input(event: InputEvent) -> void:
	if !visible: return
	if event.is_action_pressed("ui_cancel") && !menu_parent is UIPauseMenu:
		Globals.goto_prev_menu.emit()
		SoundManager.play_sound("back")


func switch_to_menu(new_parent: UIMenu) -> void:
	if new_parent.buttons.get_child_count() <= 0:
		if visible: visible = false
		return
	
	just_visible = true if !visible else false
	visible = true
	
	menu_parent = new_parent.buttons
	
	await get_tree().create_timer(0.1).timeout
	menu_index = 0
	set_cursor_from_index(menu_index)


func set_cursor_from_index(index: int, prev_index: int = -1) -> void:
	var menu_item = get_menu_item_at_index(index)
	
	if menu_item == null: return
	
	
	if prev_index != -1: get_menu_item_at_index(prev_index).unhover()
	
	menu_item.hover()
	
	var item_pos = menu_item.global_position
	var item_size = menu_item.get_rect().size

	global_position = Vector2(item_pos.x, item_pos.y + item_size.y / 2.0) - (get_rect().size / 2.0)

# NOTE: I really like ternary operators :)
func get_menu_item_at_index(index: int) -> Control: return null if menu_parent == null else menu_parent.get_child(index)

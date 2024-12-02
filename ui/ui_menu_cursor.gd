extends Label
class_name UIMenuCursor

const LIST_OFFSET: Vector2 = Vector2(0, 0)
const GRID_OFFSET: Vector2 = Vector2(-5, 0)


enum MenuType {
	LIST,
	GRID
}

var menu_type = MenuType.LIST :
	set(new_type):
		if new_type == MenuType.LIST && menu_type == MenuType.GRID: # Reset with and height if was grid
			menu_width = 0
			menu_height = 0
		elif new_type == MenuType.GRID: # Calculate width and height if grid
			var item_count = menu_parent.get_child_count()
			menu_width = menu_parent.columns
			menu_height = floor(float(item_count) / menu_width)
			menu_overflow = item_count % menu_width
		menu_type = new_type

var menu_overflow: int = 0
var menu_width: int = 0 # Use only for grid menus
var menu_height: int = 0 # Use only for grid menus

var menu_parent: Control = null
var menu_index: int = 0

var just_visible: bool = false


func _ready() -> void:
	Globals.reload_menu_cursor.connect(reload_cursor)


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
	
	
	var new_index = get_new_index_from_input_list() if menu_type == MenuType.LIST else get_new_index_from_input_grid()
	
	if new_index == -1: return
	

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
	menu_type = MenuType.LIST if !new_parent.is_grid else MenuType.GRID
	
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
	var offset: Vector2 = LIST_OFFSET if menu_type == MenuType.LIST else GRID_OFFSET
	global_position = Vector2(item_pos.x, item_pos.y + item_size.y / 2.0) - ((get_rect().size / 2.0) + offset)


func get_new_index_from_input_list() -> int:
	var input: int = 0
	if Input.is_action_just_pressed("ui_up"): input -= 1
	if Input.is_action_just_pressed("ui_down"): input += 1
	
	var new_index: int = menu_index + input
	
	if new_index > menu_parent.get_child_count() - 1: new_index = 0
	elif new_index < 0: new_index = menu_parent.get_child_count() - 1
	
	return -1 if input == 0 else menu_index + input 


func get_new_index_from_input_grid() -> int:
	var input: Vector2 = Vector2.ZERO
	if Input.is_action_just_pressed("ui_up"): input.y -= 1
	elif Input.is_action_just_pressed("ui_down"): input.y += 1
	elif Input.is_action_just_pressed("ui_left"): input.x -= 1
	elif Input.is_action_just_pressed("ui_right"): input.x += 1
	
	if input == Vector2.ZERO: return -1

	var new_pos = get_current_grid_pos() + input
	
	# Make sure cursor wraps around instead of going out of bounds
	if new_pos.x > menu_width - 1:
		new_pos.x = 0
	if new_pos.x >= menu_overflow && new_pos.y > menu_height - 1:
		new_pos.x = 0
	if new_pos.x < 0:
		if new_pos.y > (menu_height-1):
			new_pos.x = menu_overflow - 1
		else:
			new_pos.x = menu_width - 1
	if new_pos.y < 0:
		new_pos.y = menu_height - 1
	if new_pos.y > (menu_height - 1) && (new_pos.x >= menu_overflow or new_pos.y > menu_height):
		new_pos.y = 0
	
	return -1 if input == Vector2.ZERO else get_index_from_grid_pos(new_pos)


func get_current_grid_pos() -> Vector2:
	return Vector2(menu_index%menu_width, floor(float(menu_index)/menu_width))


func get_index_from_grid_pos(pos: Vector2) -> int:
	return ((pos.y * menu_width) + (pos.x))


func reload_cursor() -> void:
	set_cursor_from_index(menu_index)


# NOTE: I really like ternary operators :)
func get_menu_item_at_index(index: int) -> Control: return null if menu_parent == null else menu_parent.get_child(index)

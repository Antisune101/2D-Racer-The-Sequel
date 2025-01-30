class_name UIHighscore extends UIMenu

@export var GAME_OVER_MENU: UIMenu
@export var LOADING_MENU: UIMenu
@export var NAME_LABEL: Label
@export var DELETE_BTN: UIButton
@export var SPACE_BTN: UIButton
@export var SUBMIT_BTN: UIButton
@export var NAME_CHAR_LIMIT: int = 12

var player_name: String = Globals.player_name :
	set(new_name):
		player_name = new_name
		NAME_LABEL.text = player_name


func _ready() -> void:
	Globals.osk_letter_input.connect(_on_osk_letter_input)
	DELETE_BTN.pressed.connect(_on_osk_delete)
	SPACE_BTN.pressed.connect(_on_osk_space)
	SUBMIT_BTN.pressed.connect(_on_osk_submit)
	


func _on_osk_letter_input(letter: String) -> void:
	if player_name.length() < NAME_CHAR_LIMIT:
		player_name += letter 



func _on_osk_submit() -> void:
	if is_name_clean():
		Globals.player_name = player_name
		Globals.change_to_menu.emit(LOADING_MENU)
		await submit_score()
		Globals.change_to_menu.emit(GAME_OVER_MENU)
	else:
		pass
		#TODO: Put warning stuff here


func _on_osk_delete() -> void:
	if player_name.length() > 0:
		player_name = player_name.erase(player_name.length() - 1)


func _on_osk_space() -> void:
	if player_name.length() < NAME_CHAR_LIMIT:
		player_name += " "


func submit_score() -> void:
	await SilentWolf.Scores.save_score(Globals.player_name, Globals.score, "main").sw_save_score_complete


func is_name_clean() -> bool:
	return true

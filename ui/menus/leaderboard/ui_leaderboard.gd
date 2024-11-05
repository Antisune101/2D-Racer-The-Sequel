class_name UILeaderboard extends UIMenu

@export var ENTRY_SCENE: PackedScene
@export var SCORE_CONTAINER: VBoxContainer
@export var LOAD_LABEL: Label

func show_menu() -> void:
	super.show_menu()
	load_leadboard_entries()


func hide_menu() -> void:
	super.hide_menu()
	if SCORE_CONTAINER.get_child_count() > 0:
		clear_leaderboard_entries()


func load_leadboard_entries() -> void:
	var scores = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	var pos = 1
	for score in scores["scores"]:
		await create_leaderboard_entry(pos, score.player_name, score.score)
		pos += 1
	LOAD_LABEL.visible = false
	await  get_tree().create_timer(.1).timeout
	Globals.reload_menu_cursor.emit()


func clear_leaderboard_entries() -> void:
	for child in SCORE_CONTAINER.get_children():
		child.queue_free()
	LOAD_LABEL.visible = true
	await get_tree().create_timer(.1).timeout
	Globals.reload_menu_cursor.emit()


func create_leaderboard_entry(pos: int, p_name: String, score: int) -> void:
	var new_entry: UILeaderboardEntry = ENTRY_SCENE.instantiate()
	new_entry.set_data(pos, p_name, score)
	SCORE_CONTAINER.add_child(new_entry)


func _on_ui_refresh_button_pressed() -> void:
	clear_leaderboard_entries()
	load_leadboard_entries()

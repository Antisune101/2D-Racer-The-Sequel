extends UIMenu
class_name UIPauseMenu


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("pause_game") && !visible:
		Globals.change_to_menu.emit(self)


func show_menu() -> void:
	super.show_menu()
	SoundManager.play_sound("pause")
	get_tree().paused = true
	


func hide_menu() -> void:
	super.hide_menu()
	get_tree().paused = false

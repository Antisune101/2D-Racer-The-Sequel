extends Button


func _ready() -> void:
	pressed.connect(func(): SceneManager.change_scene("main_menu"))

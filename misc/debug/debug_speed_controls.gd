extends VBoxContainer

@export var speed_edit: SpinBox
@export var boost_edit: SpinBox
@export var brake_edit: SpinBox

@export var update_btn: Button
@export var return_btn: Button


func _ready() -> void:
	update_btn.pressed.connect(update_stuff)
	return_btn.pressed.connect(func(): SceneManager.change_scene("main_menu"))
	await get_tree().create_timer(0.01).timeout
	speed_edit.set_value_no_signal(Player.player_vehicle_speed.default_speed)
	boost_edit.set_value_no_signal(Player.player_controller.boost_amount)
	brake_edit.set_value_no_signal(Player.player_controller.brake_amount)


func update_stuff() -> void:
	speed_edit.release_focus()
	boost_edit.release_focus()
	brake_edit.release_focus()
	update_btn.release_focus()


	Player.player_vehicle_speed.speed = 0.0
	Player.player_vehicle_speed.default_speed = speed_edit.value
	Player.player_controller.boost_amount = boost_edit.value
	Player.player_controller.brake_amount = brake_edit.value

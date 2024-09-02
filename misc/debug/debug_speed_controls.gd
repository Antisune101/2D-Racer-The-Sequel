extends VBoxContainer

@export var speed_edit: SpinBox
@export var boost_edit: SpinBox
@export var brake_edit: SpinBox
@export var boost_start_edit: SpinBox
@export var brake_start_edit: SpinBox
@export var speed_reset_edit: SpinBox
@export var steer_speed_edit: SpinBox
@export var steer_friction_edit: SpinBox
@export var lane_assist_edit: SpinBox
@export var lane_assist_steer_edit: SpinBox

@export var toggle_ui_btn: Button
@export var update_btn: Button

@export var button_container: ScrollContainer

func _ready() -> void:
	update_btn.pressed.connect(update_stuff)
	toggle_ui_btn.pressed.connect(toggle_ui)
	await get_tree().create_timer(0.01).timeout
	speed_edit.value = Vehicle.player_vehicle_speed.default_speed
	boost_edit.value = Vehicle.player_controller.boost_amount
	brake_edit.value = Vehicle.player_controller.brake_amount
	boost_start_edit.value = Vehicle.player_controller.boost_start_time
	brake_start_edit.value = Vehicle.player_controller.brake_start_time
	speed_reset_edit.value = Vehicle.player_controller.reset_time
	steer_speed_edit.value = Vehicle.player_controller.steer_speed
	steer_friction_edit.value = Vehicle.player_controller.steer_reset_force
	lane_assist_edit.value = Vehicle.player_controller.lane_assist_strength
	lane_assist_steer_edit.value = Vehicle.player_controller.lane_assist_max_steer


func toggle_ui() -> void:
	update_btn.visible = !update_btn.visible
	button_container.visible = update_btn.visible


func update_stuff() -> void:
	release_focus_on_stuff()


	Vehicle.player_vehicle_speed.speed = 0.0
	Vehicle.player_vehicle_speed.default_speed = speed_edit.value
	Vehicle.player_controller.boost_amount = boost_edit.value
	Vehicle.player_controller.brake_amount = brake_edit.value
	Vehicle.player_vehicle_speed.default_speed = speed_edit.value
	Vehicle.player_controller.boost_amount = boost_edit.value
	Vehicle.player_controller.brake_amount = brake_edit.value
	Vehicle.player_controller.boost_start_time = boost_start_edit.value
	Vehicle.player_controller.brake_start_time = brake_start_edit.value
	Vehicle.player_controller.reset_time = speed_reset_edit.value
	Vehicle.player_controller.steer_speed = steer_speed_edit.value
	Vehicle.player_controller.steer_reset_force = steer_friction_edit.value
	Vehicle.player_controller.lane_assist_strength = lane_assist_edit.value
	Vehicle.player_controller.lane_assist_max_steer = lane_assist_steer_edit.value


func release_focus_on_stuff() -> void:
	var vbox = button_container.get_child(0)
	for i in vbox.get_children():
		for child in i.get_children():
			if child is SpinBox: child.release_focus()
	update_btn.release_focus()
	toggle_ui_btn.release_focus()

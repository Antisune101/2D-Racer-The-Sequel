extends Control
class_name UIMenu

@onready var buttons: Control = $PanelContainer/MarginContainer/VBoxContainer/Buttons


func show_menu() -> void: visible = true


func hide_menu() -> void: visible = false

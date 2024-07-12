extends Node

@onready var ui_click: AudioStreamPlayer2D = $UIClick
@onready var ui_select: AudioStreamPlayer2D = $UISelect


func play_ui_click() -> void:
	ui_click.play()


func play_ui_select() -> void:
	ui_select.play()

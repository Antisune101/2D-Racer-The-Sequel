extends Node


@onready var ui_sounds: Dictionary = {
	"select": $UISelect,
	"move_cursor": $UIMoveCursor,
	"back": $UIBack,
	"pause": $UIPause,
	"score": $Score
}


func play_sound(sound_id: String) -> void:
	ui_sounds[sound_id].play()

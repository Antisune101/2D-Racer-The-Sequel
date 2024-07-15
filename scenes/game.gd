extends Node2D


@export var score_label: Label

var game_over: bool = false
var score: int = 0
var score_hundreth: int = 0


func _ready() -> void:
	update_score()
	Globals.game_over.connect(func(): game_over = true)


func update_score() -> void:
	if game_over: return
	
	score += 1
	if score % 100 == 0 && score / 100 > score_hundreth:
		score_hundreth = score / 100
		SoundManager.play_sound("score")
	
	score_label.text = str(score).pad_zeros(5)
	await get_tree().create_timer(0.1).timeout
	update_score()

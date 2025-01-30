extends Node2D


@export var score_label: Label
@export var game_over_menu: UIMenu

var game_over: bool = false
var score_hundreth: int = 0


func _ready() -> void:
	Globals.score = 0
	update_score()
	Globals.game_over.connect(_on_game_over)


func update_score() -> void:
	if game_over: return
	
	Globals.score += 1
	if Globals.score % 100 == 0 && Globals.score / 100 > score_hundreth:
		score_hundreth = Globals.score / 100
		SoundManager.play_sound("score")
	
	score_label.text = str(Globals.score).pad_zeros(5)
	await get_tree().create_timer(0.1).timeout
	update_score()


func _on_game_over() -> void:
	game_over = true
	var top_scores: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	
	if top_scores.scores.size() < 10  || Globals.score > top_scores.scores[-1].score:
		SceneManager.transition_to_scene("hall_of_fame")
	else:
		Globals.change_to_menu.emit(game_over_menu)

class_name UILeaderboardEntry extends HBoxContainer


func set_data(pos: int, p_name: String, score: int) -> void:
	$Position.text = str(pos) + "."
	$Name.text = p_name
	$Score.text = str(score)

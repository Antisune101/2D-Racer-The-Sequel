extends Node2D


func _ready() -> void:
	Globals.game_over.connect(explode)


func explode() -> void:
	$AnimationPlayer.play("explode")
	$AudioStreamPlayer2D.play()

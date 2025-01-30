extends CanvasLayer


@export var game_over_menu: UIMenu

@onready var anim_player = $AnimationPlayer


func _ready() -> void:
	await Globals.game_over
	anim_player.play("GameOver")
	await anim_player.animation_finished

extends Node2D

@export_category("Trans Animation")
@export var duration: float
@export var pause: float


var current_scene: String = "main_menu"
var is_transitioning: bool = false


@onready var cover: ColorRect = $CanvasLayer/ColorRect
@onready var cover_width: float = cover.size.x


const SCENES: Dictionary = {
	"main_menu": "res://scenes/title_screen.tscn",
	"game": "res://scenes/game.tscn",
	"debug": "res://scenes/debug_game.tscn"
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	cover.position.x = -cover_width


func change_scene(new_scene: String) -> void:
	current_scene = new_scene
	transition_to_scene(new_scene)


func reload_scene() -> void:
	transition_to_scene(current_scene)

func transition_to_scene(new_scene: String) -> void:
	is_transitioning = true

	await cover_screen()
	get_tree().change_scene_to_file(SCENES[new_scene])
	show_screen()
	get_tree().paused = false
	is_transitioning = false


func cover_screen() -> void:
	await get_tween().set_ease(Tween.EASE_IN).tween_property(cover, "position", Vector2.ZERO, duration).finished


func show_screen() -> void:
	await get_tween().set_ease(Tween.EASE_IN_OUT).tween_property(cover, "position", Vector2(cover_width, 0), duration).finished
	cover.position = Vector2(-cover_width, 0)


func get_tween() -> Tween:
	return get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_trans(Tween.TRANS_EXPO)

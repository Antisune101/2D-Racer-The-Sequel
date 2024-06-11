extends Node2D

@export_category("Trans Animation")
@export var duration: float
@export var pause: float


var is_title_screen: bool = true
var is_transitioning: bool = false


@onready var cover: ColorRect = $CanvasLayer/ColorRect
@onready var cover_width: float = cover.size.x


func _ready() -> void:
	cover.position.x = -cover_width


func change_scene() -> void:
	if is_transitioning: return
	
	is_transitioning = true
	
	var new_scene = "res://scenes/game.tscn" if is_title_screen else "res://scenes/title_screen.tscn"
	is_title_screen = !is_title_screen
	
	await cover_screen()
	get_tree().change_scene_to_file(new_scene)
	show_screen()
	is_transitioning = false

func reload_scene() -> void: get_tree().reload_current_scene()


func cover_screen() -> void:
	await get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).tween_property(cover, "position", Vector2.ZERO, duration).finished


func show_screen() -> void:
	await get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).tween_property(cover, "position", Vector2(cover_width, 0), duration).finished
	cover.position = Vector2(-cover_width, 0)

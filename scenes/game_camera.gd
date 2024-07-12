extends Camera2D
class_name GameCamera


@export var boost_zoom: float = 0.9
@export var brake_zoom: float = 1.1


var anim_tween: Tween
var shake_strength: float

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("boost"): animate_zoom(boost_zoom)
	if Input.is_action_just_pressed("brake"): animate_zoom(brake_zoom)
	if Input.is_action_just_released("boost") || Input.is_action_just_released("brake"): animate_zoom(1.0)


func animate_zoom(target_zoom: float) -> void:
	get_tree().create_tween().tween_property(self, "zoom", Vector2(target_zoom, target_zoom), 0.5)

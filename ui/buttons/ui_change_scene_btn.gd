extends UIButton
class_name UIChangeSceneBtn

@export var reload_current_scene: bool = false
@export var scene_id: String

func select() -> void:
	if SceneManager.is_transitioning: return
	
	if reload_current_scene: SceneManager.reload_scene()
	else: SceneManager.change_scene(scene_id)

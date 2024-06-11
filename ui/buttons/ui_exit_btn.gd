extends UIButton
class_name UIExitBtn


func _ready() -> void: if OS.has_feature("web"): queue_free()


func select() -> void: get_tree().quit()

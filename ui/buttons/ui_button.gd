extends Label
class_name UIButton


func select() -> void: pass


func hover() -> void:
	scale = Vector2(1.1, 1.1)


func unhover() -> void:
	scale = Vector2.ONE

extends Label
class_name UIButton


signal pressed


func select() -> void: pressed.emit()


func hover() -> void:
	scale = Vector2(1.1, 1.1)


func unhover() -> void:
	scale = Vector2.ONE

@tool
class_name UIOskLetterBtn extends UIButton


@export var letter: String = "" : 
	set(new_letter):
		if Engine.is_editor_hint():
			letter = new_letter.to_upper()
			text = letter
			name = letter


func select() -> void:
	Globals.osk_letter_input.emit(self.text)

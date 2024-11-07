@tool
class_name UIMenuTitle extends Control

@export var TITLE_TEXT: String = "" :
	set(value):
		TITLE_TEXT = value
		print(value)
		%Title.text = TITLE_TEXT
@export var SUB_TITLE_TEXT: String = "" :
	set(value):
		SUB_TITLE_TEXT = value
		%SubTitle.text = SUB_TITLE_TEXT

@tool
class_name UIMenuTitle extends Control

#const TITLE_NODE := "CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Title"
#const SUB_TITLE_NODE := "CenterContainer/PanelContainer/MarginContainer/VBoxContainer/SubTitle"

@export var TITLE_NODE: Label
@export var SUB_TITLE_NODE: Label


@export var TITLE_TEXT: String = "" :
	set(value):
		if !Engine.is_editor_hint(): return
		TITLE_TEXT = value
		update_title(TITLE_NODE, TITLE_TEXT)

@export var SUB_TITLE_TEXT: String = "" :
	set(value):
		if !Engine.is_editor_hint(): return
		SUB_TITLE_TEXT = value
		update_title(SUB_TITLE_NODE, SUB_TITLE_TEXT)


func update_title(label: Label, text: String) -> void:
		if !Engine.is_editor_hint(): return
		if text == "":
			label.visible = false
		else:
			label.text = text
			if !label.visible: label.visible = true

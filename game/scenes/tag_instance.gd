class_name TagInstance extends Control

var _tag : Tag
@export var tag : Tag :
	get: return _tag
	set(value):
		if _tag == value: return
		_tag = value
		_tag.name_changed.connect(on_name_changed)

@export var label_button : Button

func populate(__tag: Tag) -> void:
	tag = __tag

func _on_label_button_pressed() -> void:
	pass

func _on_remove_button_pressed() -> void:
	remove()

func remove() -> void:
	queue_free()


func on_name_changed(new_text: String) -> void:
	label_button.text = new_text

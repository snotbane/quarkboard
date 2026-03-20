## A single file that contains user-created content.
class_name Quark extends JsonResource

const DIR_NAME := "quarks"

@export var text : String

func _ready() -> void:
	parent.quark_added.emit(self)


func open_in_editor() -> void:
	pass

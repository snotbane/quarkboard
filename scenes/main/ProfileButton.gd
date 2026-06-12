extends Control

var element: Variant

func populate(__element__) -> void:
	element = __element__


func _ready() -> void:
	$label.text = str(element)

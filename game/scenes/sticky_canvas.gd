extends GraphEdit

@onready var scroll_layer : Control = self.get_child(-2, true)

@export var prefab_note : PackedScene

func _ready() -> void:
	scroll_layer.visible = false
	pass


func _on_add_new_node_pressed() -> void:
	self.add_child(prefab_note.instantiate())




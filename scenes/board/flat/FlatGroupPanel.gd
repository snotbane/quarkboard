
@tool extends PanelContainer

var label : Label :
	get: return $v_box_container/label

var container : KeepFlowContainer :
	get: return $v_box_container/container

@export var label_text : String :
	get: return label.text
	set(value): label.text = value

@export var size_target : Control :
	get: return container.size_target
	set(value):
		container.size_target = value
		container._refresh_column_count()


func _ready() -> void:
	if Engine.is_editor_hint(): return

	container.items_changed.connect(_container_items_changed)


func _container_items_changed() -> void:
	visible = container.get_grandchild_count() > 0


func add_grandchild(control: Control) -> void:
	container.add_grandchild(control)


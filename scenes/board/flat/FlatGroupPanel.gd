
@tool class_name FlatGroupPanel extends PanelContainer

var label : Label :
	get: return $v_box_container/label

var container : MasonContainer :
	get: return $v_box_container/container

@export var label_text : String :
	get: return label.text
	set(value): label.text = value

@export var status : Quark.Status

@export var size_target : Control :
	get: return container.size_target
	set(value):
		container.size_target = value
		container._refresh_beam_count()


func _ready() -> void:
	if Engine.is_editor_hint(): return

	visibility_changed.connect(_container_items_changed)
	container.items_changed.connect(_container_items_changed)


func _container_items_changed() -> void:
	visible = container.get_brick_count() > 0


func add_brick(control: Control) -> void:
	container.add_brick(control)


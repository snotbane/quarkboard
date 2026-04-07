
@tool class_name FlatGroupPanel extends PanelContainer

var masonry : MasonryContainer :
	get: return %masonry

var _label_text : String
@export var label_text : String :
	get: return %label.text
	set(value):
		_label_text = value
		if not is_node_ready(): return

		%label.text = value
		%label.visible = not %label.text.is_empty()

@export var status : Quark.Status


func _ready() -> void:
	label_text = _label_text

	if Engine.is_editor_hint(): return

	visibility_changed.connect(_container_items_changed)
	%masonry.child_order_changed.connect(_container_items_changed)


func _container_items_changed() -> void:
	if %masonry == null: return

	visible = %masonry.get_child_count() > 0

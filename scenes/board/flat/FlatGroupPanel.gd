
@tool class_name FlatGroupPanel extends PanelContainer

var label : Label :
	get: return $v_box_container/label

var masonry : MasonryContainer :
	get: return $v_box_container/masonry

@export var label_text : String :
	get: return label.text
	set(value): label.text = value

@export var status : Quark.Status


func _ready() -> void:
	if Engine.is_editor_hint(): return

	visibility_changed.connect(_container_items_changed)
	masonry.child_order_changed.connect(_container_items_changed)


func _container_items_changed() -> void:
	if masonry == null: return

	visible = masonry.get_child_count() > 0

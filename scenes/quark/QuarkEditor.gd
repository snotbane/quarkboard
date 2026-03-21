
class_name QuarkEditor extends Control

const WINDOW_SCENE := preload("uid://dhqywdywggsx5")

var quark : Quark :
	get: return $resource_socket.resource
	set(value):
		$resource_socket.resource = value
		text_edit.text = quark.text
		name = quark.name_text


static var subwindow : Control :
	get: return GlobalNode.get_global_node(&"quark_editor_subwindow")
static var subwindow_container : Control :
	get: return GlobalNode.get_global_node(&"quark_editor_container")

@onready var text_edit : TextEdit = $safe_margin_container/panel_container/v_box_container/text_panel/v_box_container/text

var window : Window

func _ready() -> void:
	text_edit.text_changed.connect(_text_changed)


func _text_changed() -> void:
	quark.text = text_edit.text
	quark.save()

	name = quark.name_text
	if window:
		window.refresh_title()


func popout() -> void:
	if window: return

	window = WINDOW_SCENE.instantiate()
	window.content_scale_factor = get_tree().root.content_scale_factor
	window.size = size
	window.position = position

	get_tree().root.add_child(window)
	window.show()

	reparent(window)
	window.refresh_title()

	set_anchors_preset(Control.PRESET_FULL_RECT)
	position = Vector2.ZERO

	subwindow.hide()


func popin() -> void:
	if not window: return

	subwindow.show()
	reparent(subwindow_container)
	window.queue_free()

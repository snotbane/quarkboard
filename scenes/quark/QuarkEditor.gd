
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
@onready var popout_button : BaseButton = $safe_margin_container/panel_container/v_box_container/meta_bar/title_bar/popout_popin
@onready var pin_switch : BaseButton = $safe_margin_container/panel_container/v_box_container/meta_bar/title_bar/pin_unpin

var _window : Window
var window : Window :
	get: return _window
	set(value):
		_window = value
		pin_switch.visible = _window != null
		pin_switch.button_pressed = _window.always_on_top if _window else false


func _ready() -> void:
	text_edit.text_changed.connect(_text_changed)


func _text_changed() -> void:
	quark.text = text_edit.text
	quark.save()

	name = quark.name_text
	if window:
		window.refresh_title()


func close() -> void:
	queue_free()

	if window:
		window.queue_free()
	else:
		subwindow.hide()


func set_popout(value: bool) -> void:
	if value:
		popout()
	else:
		popin()


func popout() -> void:
	if window: return

	window = WINDOW_SCENE.instantiate()
	window.content_scale_factor = get_tree().root.content_scale_factor
	window.position = get_screen_position()
	window.size = size

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
	window = null


func popout_direct() -> void:
	popout()
	window.size = get_tree().root.size * 0.75
	window.position = get_tree().root.position + (get_tree().root.size - Vector2i(size.floor())) / 2
	show()
	popout_button.hide()
	popout_button.button_pressed = true




var pinned : bool :
	get: return window.always_on_top if window else false
	set(value):
		if not window: return
		window.always_on_top = value
func set_pinned(value: bool) -> void:
	pinned = value


func recycle() -> void:
	pass # Replace with function body.
	close()


func delete() -> void:
	quark.delete()
	close()


func copy() -> void:
	quark.copy()
	close()

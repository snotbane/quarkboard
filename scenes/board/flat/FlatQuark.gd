
class_name FlatQuarkViewer extends Control

const HOVER_FADE_DURATION := 0.333

var quark : Quark :
	get: return socket.resource
	set(value): socket.resource = value


@onready var preview_label : PreviewLabel = %preview_label
@onready var socket : ResourceSocket = $resource_socket

var board : FlatView

func _enter_tree() -> void:
	board = Myth.find_ancestor_of_type(self, "FlatView")


func _ready() -> void:
	# mouse_entered.connect(_on_mouse_entered)
	# mouse_exited.connect(_on_mouse_exited)

	%actions.modulate = Color.TRANSPARENT

	socket.resource_changed.connect(_on_resource_changed)
	socket.resource_value_changed.connect(_on_resource_value_changed.unbind(1))


func _on_mouse_entered() -> void:
	create_tween() \
		.tween_property(%actions, "modulate", Color.WHITE, HOVER_FADE_DURATION) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)


func _on_mouse_exited() -> void:
	create_tween() \
		.tween_property(%actions, "modulate", Color.TRANSPARENT, HOVER_FADE_DURATION) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)


func _on_resource_changed() -> void:
	preview_label.set_content(socket.resource.text if socket.resource else "")

	var container : FlatGroupPanel = Myth.find_ancestor_of_type(self, "FlatGroupPanel")
	if container.status != quark.status:
		reparent(board.get_container_for_quark(quark).masonry)


func _on_resource_value_changed() -> void:
	if socket.resource:
		socket.resource.deleted.connect(queue_free)

	_on_resource_changed()

var _hovering : bool
var hovering : bool :
	get: return _hovering
	set(value):
		if _hovering == value: return
		_hovering = value

		if _hovering:
			_on_mouse_entered()
		else:
			_on_mouse_exited()

var mouse_position : Vector2

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		_on_pressed()
		get_viewport().set_input_as_handled()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = event.global_position
		hovering = get_global_rect().has_point(event.global_position)


func _on_pressed() -> void:
	quark.open_in_editor()


func _on_popout_pressed() -> void:
	quark.open_in_editor(true)

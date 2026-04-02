
class_name FlatQuarkViewer extends Control


var quark : Quark :
	get: return socket.resource
	set(value): socket.resource = value


@onready var preview_label : PreviewLabel = %preview_label
@onready var socket : ResourceSocket = $resource_socket

var board : FlatView

func _enter_tree() -> void:
	board = Myth.find_ancestor_of_type(self, "FlatView")


func _ready() -> void:
	socket.resource_changed.connect(_on_resource_changed)
	socket.resource_value_changed.connect(_on_resource_value_changed.unbind(1))


func _on_resource_changed() -> void:
	preview_label.set_content(socket.resource.text if socket.resource else "")

	var container : FlatGroupPanel = Myth.find_ancestor_of_type(self, "FlatGroupPanel")
	if container.status != quark.status:
		reparent(board.get_container_for_quark(quark).masonry)
		# get_parent().get_parent().remove_brick(self)
		# board.get_container_for_quark(quark).add_brick(self)


func _on_resource_value_changed() -> void:
	if socket.resource:
		socket.resource.deleted.connect(queue_free)

	_on_resource_changed()


func _on_pressed() -> void:
	quark.open_in_editor()


func _on_popout_pressed() -> void:
	quark.open_in_editor(true)


func _on_tag_selected(tag: String) -> void:
	if quark.tags.has(tag): return

	quark.tags.push_back(tag)
	quark.save()


func _on_tag_removed(tag: String) -> void:
	if not quark.tags.has(tag): return

	quark.tags.erase(tag)
	quark.save()

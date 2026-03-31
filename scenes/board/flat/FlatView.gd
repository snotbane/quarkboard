
class_name FlatView extends BoardView

const FLAT_QUARK_SCENE = preload("uid://ik6dmd4algrl")

static var REGEX_TITLE := RegEx.create_from_string(r"^\s*(\S.*?)\n")


static func get_title_text(string: String) -> String:
	return REGEX_TITLE.search(string).get_string(1)


func _ready() -> void:
	Machine.inst.active_profile_quark_added.connect(_quark_added)

	for quark in Machine.active_profile.quarks:
		_quark_added(quark)


func get_container_for_quark(quark: Quark) -> FlatGroupPanel:
	var result : FlatGroupPanel
	match quark.status:
		Quark.Status.FLAG:
			result = %flag
		Quark.Status.ARCHIVE:
			result = %archive
		Quark.Status.RECYCLE:
			result = %recycle
		_:
			result = %none

	return result


func _quark_added(quark: Quark) -> void:
	var container := get_container_for_quark(quark)
	if container == null: return

	var node : FlatQuarkViewer = FLAT_QUARK_SCENE.instantiate()

	container.masonry.add_child(node)

	await get_tree().process_frame

	node.quark = quark


func create_new_quark() -> void:
	var quark : Quark
	var path := JsonResource.generate_save_path(Machine.active_profile.file_path_absolute.path_join(Quark.DIR_NAME))

	quark = Quark.new()
	quark.touch(path)
	quark.open_in_editor()

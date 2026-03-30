
class_name FlatView extends BoardView

const FLAT_QUARK_SCENE = preload("uid://ik6dmd4algrl")

static var REGEX_TITLE := RegEx.create_from_string(r"^\s*(\S.*?)\n")


static func get_title_text(string: String) -> String:
	return REGEX_TITLE.search(string).get_string(1)


@onready var main_container : FlatGroupPanel = %none
@onready var flag_container : FlatGroupPanel = %flag
@onready var archive_container : FlatGroupPanel = %archive


func _ready() -> void:
	Machine.inst.active_profile_quark_added.connect(_quark_added)

	for quark in Machine.active_profile.quarks:
		_quark_added(quark)


func get_container_for_quark(quark: Quark) -> FlatGroupPanel:
	var result : FlatGroupPanel
	match quark.status:
		Quark.Status.NONE:
			result = main_container
		Quark.Status.FLAG:
			result = flag_container
		Quark.Status.ARCHIVE:
			result = archive_container

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

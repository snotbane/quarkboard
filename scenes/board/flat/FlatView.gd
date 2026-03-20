
extends BoardView

const FLAT_QUARK_SCENE = preload("uid://ik6dmd4algrl")


@onready var container : KeepFlowContainer = $h_box_container/quark_panel/scroll_container/margin_container/v_box_container/flat_flow_container


func _ready() -> void:
	Machine.inst.active_profile_quark_added.connect(_quark_added)

	for quark in Machine.active_profile.quarks:
		_quark_added(quark)


func _quark_added(quark: Quark) -> void:
	var node : FlatQuarkViewer = FLAT_QUARK_SCENE.instantiate()
	container.add_grandchild(node)

	await get_tree().process_frame

	node.quark = quark


func create_new_quark() -> void:
	var quark : Quark
	var path := JsonResource.generate_save_path(Machine.active_profile.file_path_absolute.path_join(Quark.DIR_NAME))

	quark = Quark.new()
	quark.touch(path)
	quark.open_in_editor()

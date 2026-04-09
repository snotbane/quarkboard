## Acts as a master folder and contains all notes.
class_name Profile extends TaggedJsonResource

const DIR_EXT := ".qbdp"
const ICON_DEFAULT = preload("uid://d1f31r2b2kbdd")
const ICON_NULL := preload("uid://tn6tigaqju6d")

static var REGEX_PATTERN_PROFILE_PATH := RegEx.create_from_string(".*\\%s$" % DIR_EXT)

signal quark_added(quark: Quark)
signal boards_changed

@export_storage var name : String
@export_storage var icon : Texture2D = ICON_DEFAULT

var quarks : Array
var boards : Array

func _get_save_as_dir_default() -> bool: return true


func _init() -> void:
	super._init()

	tags.use_references = false


func _touched() -> void:
	if not is_valid: return

	if name.is_empty():
		name = file_name.capitalize()
		self.save()

	_touched_deferred.call_deferred()
func _touched_deferred() -> void:
	assert(Machine.inst != null)

	if not Machine.profiles.has(self):
		Machine.profiles[self] = file_path_absolute
		Machine.inst.save()
		Machine.inst.profile_added.emit(self)


func _loaded() -> void:
	if not is_valid: return

	# tags.clear()
	# for path in Myth.get_paths_in_folder(file_path_absolute.path_join(Tag.DIR_NAME)):
	# 	if path.get_extension().is_empty(): continue

	# 	var tag := Tag.new()
	# 	tag.load(path)

	# 	tags.append(tag)

	quarks.clear()
	for path in Myth.get_paths_in_folder(file_path_absolute.path_join(Quark.DIR_NAME)):
		if path.get_extension().is_empty(): continue

		var quark := Quark.new()
		quark.load(path)

		quarks.push_back(quark)

	boards.clear()
	for path in Myth.get_paths_in_folder(file_path_absolute.path_join(Board.DIR_NAME)):
		if path.get_extension().is_empty(): continue

		var board := Board.new()
		board.load(path)

	print("Found %s Quarks and %s Boards in profile '%s'" % [ quarks.size(), boards.size(), file_path_absolute ])


func make_active() -> void:
	Machine.active_profile = self


func hide() -> void:
# if Machine.profiles.has(self):
	Machine.active_profile = null
	Machine.profiles.erase(self)
	Machine.inst.save()
	Machine.inst.profile_removed.emit(self)


func delete() -> void:
	hide()

	super.delete()


func can_add_tag(tag: String) -> bool:
	return not (tags.is_empty() or tags.has_by_name(tag))


func rename_tag_globally(tag_name: String, new_tag: String) -> void:
	new_tag = Tag.format_string_for_tag(new_tag)

	assert(tags.has_by_name(tag_name))
	if not can_add_tag(new_tag): return

	var tag := tags.find_by_name(tag_name)
	tag.name = new_tag

	# for quark in quarks:
	# 	if not quark.tags.has(tag): continue

	# 	quark.tags.erase(tag)
	# 	quark.tags.push_back(new_tag)
	# 	quark.save()

	# for board in boards:
	# 	if not board.tags.has(tag): continue

	# 	board.tags.erase(tag)
	# 	board.tags.push_back(new_tag)
	# 	board.save()

	# tags.erase(tag)
	# tags.push_back(new_tag)
	# save()
	# tags_changed.emit()


func remove_tag_globally(tag: Tag) -> void:
	assert(tags.has(tag))

	tags.erase(tag)

	# for quark in quarks:
	# 	if not quark.tags.has(tag): continue

	# 	quark.tags.erase(tag)
	# 	quark.save()

	# for board in boards:
	# 	if not board.tags.has(tag): continue

	# 	board.tags.erase(tag)
	# 	board.save()

	# tags.erase(tag)
	# save()
	# tags_changed.emit()


## A single file that contains user-created content.
class_name Quark extends JsonResource

const DIR_NAME := "quarks"
const EDITOR_SCENE := preload("uid://cvqmvnonuqn32")
const MAX_NAME_LENGTH := 50

static var REGEX_TITLE_TEXT := RegEx.create_from_string(r"^\s*(\S.*?)(?:\n|$)")
static var REGEX_NAME_TEXT := RegEx.create_from_string(r"[\.:@/\"%]")


@export var text : String


var title_text : String :
	get:
		var match := REGEX_TITLE_TEXT.search(text)
		return match.get_string(1) if match else ""

var name_text : String :
	get: return REGEX_NAME_TEXT.sub(title_text, "", true).substr(0, MAX_NAME_LENGTH)


var editor : QuarkEditor


func _ready() -> void:
	parent.quark_added.emit(self)


func open_in_editor(separate_window: bool = false) -> void:
	if editor:
		if editor.window:
			editor.window.move_to_foreground()
			return
	else:
		editor = EDITOR_SCENE.instantiate()
		GlobalNode.get_global_node(&"quark_editor_container").add_child(editor)
		await editor.get_tree().process_frame

	editor.quark = self
	GlobalNode.get_global_node(&"quark_editor_subwindow").show()


func close_in_editor() -> void:
	if not editor: return

	editor.queue_free()
	editor = null


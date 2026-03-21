
extends Label

static var REGEX_TITLE := RegEx.create_from_string(r"^\s*(\S.*?)(?:\n|$)")

static func get_title_text(string: String) -> String:
	var match := REGEX_TITLE.search(string)
	return match.get_string(1) if match else ""


@export var text_edit : TextEdit


func _ready() -> void:
	assert(text_edit != null)

	text_edit.text_changed.connect(_on_text_changed)
	_on_text_changed.call_deferred()


func _on_text_changed() -> void:
	text = get_title_text(text_edit.text)



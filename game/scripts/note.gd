class_name Note extends TaggedResource

const NOTES_SUBFOLDER_NAME := "notes"

const K_TITLE := "title"
const K_TEXT := "text"

const DEFAULT_TITLE := "New Note"

static var RE_JSON_PATH_LOCAL := RegEx.create_from_string(r"\.json$")
static var RE_ANY_NON_WHITESPACE := RegEx.create_from_string(r"\S")
static var RE_TRIM_WHITESPACE := RegEx.create_from_string(r"(?ms)^\s+|(?:\s+$(?=\S))")

var _title : String
@export var title : String :
	get: return _title
	set(value):
		if _title == value: return
		_title = value
		commit_changes()

var _text : String
@export var text : String :
	get: return _text
	set(value):
		if _text == value: return
		_text = value
		commit_changes()

var trimmed_text : String :
	get: return RE_TRIM_WHITESPACE.sub(text, String(), true)

var placeholder_title : String :
	get:
		var trim := trimmed_text
		var result := trim.substr(0, trim.find("\n"))
		return Note.DEFAULT_TITLE if result.is_empty() else result


func _import_json(json: Dictionary) -> void:
	super._import_json(json)
	self._title = json[K_TITLE]
	self._text = json[K_TEXT]
	# self.tags = json[K_TAGS]


func _export_json(json: Dictionary) -> void:
	json.merge({
		K_TITLE: title,
		K_TEXT: text,
		# K_TAGS: tags.map(func(tag: Tag): return tag.name),
	}, true)


func set_text(new_text: String) -> void:
	text = new_text

static func string_is_blank(s: String) -> bool:
	return RE_ANY_NON_WHITESPACE.search(s) == null


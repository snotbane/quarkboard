class_name Entry extends TaggedResource

const SECONDS_IN_DAY := 86400
const SECONDS_IN_HOUR := 3600
const SECONDS_IN_MINUTE := 60

const FOLDER_PATH := "user://entry/"

const K_TITLE := "title"
const K_TEXT := "text"
const K_TIME_CREATED := "time_created"
const K_TIME_MODIFIED := "time_modified"

const DEFAULT_TITLE := "New Note"

const TENSE_PAST := "ago"
const TENSE_FUTURE := "...in the future?"
const TENSE_NOW := "now"
const TENSE_UNKNOWN := "...in a time unknown..."

static var RE_JSON_PATH := RegEx.create_from_string(r"\.json$")
static var RE_ANY_NON_WHITESPACE := RegEx.create_from_string(r"\S")
static var RE_TRIM_WHITESPACE := RegEx.create_from_string(r"(?ms)^\s+|(?:\s+$(?=\S))")

static var NOW : int :
	get: return floori(Time.get_unix_time_from_system())


static var REGISTRY : Array[Entry]

static func _static_init() -> void:
	var paths := MincuzUtils.get_paths_in_folder(FOLDER_PATH, RE_JSON_PATH)
	for path in paths:
		var entry := Entry.new()
		entry.load_file(path)
		REGISTRY.push_back(entry)


signal modified

var _title : String
@export var title : String :
	get: return _title
	set(value):
		if _title == value: return
		_title = value
		save_changes()
var _text : String
@export var text : String :
	get: return _text
	set(value):
		if _text == value: return
		_text = value
		save_changes()
@export var time_created : int
@export var time_modified : int

var trimmed_text : String :
	get: return RE_TRIM_WHITESPACE.sub(text, String(), true)

var placeholder_title : String :
	get:
		var trim := trimmed_text
		var result := trim.substr(0, trim.find("\n"))
		return Entry.DEFAULT_TITLE if result.is_empty() else result

var last_modified_short_blurb : String :
	get: return Entry.datetime_relative_blurb(time_modified)

var time_tooltip : String :
	get: return "Created %s\nLast modified %s" % [Entry.datetime_long_blurb(time_created), Entry.datetime_long_blurb(time_modified)]

func _init() -> void:
	super._init()
	title = ""
	text = ""
	time_created = 0
	time_modified = 0


func _export_json(json: Dictionary) -> void:
	json.merge({
		K_TITLE: title,
		K_TEXT: text,
		# K_TAGS: tags.map(func(tag: Tag): return tag.name),
		K_TIME_CREATED: time_created,
		K_TIME_MODIFIED: time_modified,
	}, true)
	print("export: ", json)

func _import_json(json: Dictionary) -> void:
	super._import_json(json)
	self.title = json[K_TITLE]
	self.text = json[K_TEXT]
	# self.tags = json[K_TAGS]
	self.time_created = json[K_TIME_CREATED]
	self.time_modified = json[K_TIME_MODIFIED]
	print("import: ", json)
	print("time_created: ", self.time_created)


func save_changes() -> void:
	time_modified = NOW
	save_file(get_save_path(FOLDER_PATH))
	modified.emit()


func set_text(new_text: String) -> void:
	text = new_text

static func string_is_blank(s: String) -> bool:
	return RE_ANY_NON_WHITESPACE.search(s) == null

## Adapted from:	https://github.com/godotengine/godot-proposals/issues/5515#issuecomment-1409971613
static func get_local_datetime(unix_time: int) -> int:
	return unix_time + Time.get_time_zone_from_system().bias * SECONDS_IN_MINUTE


static func datetime_long_blurb(unix_time: int) -> String:
	return Time.get_datetime_string_from_unix_time(get_local_datetime(unix_time), true)


static func datetime_short_blurb(unix_time: int) -> String:
	if absi(NOW - unix_time) > SECONDS_IN_DAY:
		return Time.get_date_string_from_unix_time(get_local_datetime(unix_time))
	else:
		return Time.get_time_string_from_unix_time(get_local_datetime(unix_time))


static func datetime_relative_blurb(unix_time: int) -> String:
	var now := NOW
	var tense : String = TENSE_PAST if now - unix_time > 0 else TENSE_FUTURE

	var now_dict := Time.get_datetime_dict_from_unix_time(now)
	var then_dict := Time.get_datetime_dict_from_unix_time(unix_time)
	now_dict.erase(&"second")

	for k in now_dict.keys():
		var diff : int = absi(now_dict[k] - then_dict[k])
		if diff == 0: continue
		return "%s %s%s %s" % [diff, k, "s" if diff != 1 else "", tense]

	return TENSE_NOW

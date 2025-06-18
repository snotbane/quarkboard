class_name JsonResource extends Resource

#region Static

const SECONDS_IN_DAY := 86400
const SECONDS_IN_HOUR := 3600
const SECONDS_IN_MINUTE := 60

const K_TIME_CREATED := "time_created"
const K_TIME_MODIFIED := "time_modified"

const TENSE_PAST := "ago"
const TENSE_FUTURE := "...in the future?"
const TENSE_NOW := "now"
const TENSE_UNKNOWN := "...in a time unknown..."

const FILE_EXT := ".json"
static var RE_JSON_PATH := RegEx.create_from_string(r"\.json$")


static func get_resource_uid_path(resource: Resource) -> String:
	if resource == null: return ""
	return ResourceUID.id_to_text(ResourceLoader.get_resource_uid(resource.resource_path))


# static func new_from_json(json: Dictionary) -> JsonResource:
# 	var result := JsonResource.new()
# 	result.import_json(json)
# 	return result

# static func new_from_load(path: String, template := JsonResource.new()) -> JsonResource:
# 	template.load_from_file(path)
# 	return template


## Adapted from:	https://github.com/godotengine/godot-proposals/issues/5515#issuecomment-1409971613
static func get_local_datetime(unix_time: int) -> int:
	return unix_time + Time.get_time_zone_from_system().bias * SECONDS_IN_MINUTE


static func datetime_long_blurb(unix_time: int) -> String:
	return Time.get_datetime_string_from_unix_time(get_local_datetime(unix_time), true)


static func datetime_short_blurb(unix_time: int) -> String:
	if absi(MincuzUtils.NOW - unix_time) > SECONDS_IN_DAY:
		return Time.get_date_string_from_unix_time(get_local_datetime(unix_time))
	else:
		return Time.get_time_string_from_unix_time(get_local_datetime(unix_time))


static func datetime_relative_blurb(unix_time: int) -> String:
	var now := MincuzUtils.NOW
	var tense : String = TENSE_PAST if now - unix_time > 0 else TENSE_FUTURE

	var now_dict := Time.get_datetime_dict_from_unix_time(now)
	var then_dict := Time.get_datetime_dict_from_unix_time(unix_time)
	now_dict.erase(&"second")

	for k in now_dict.keys():
		var diff : int = absi(now_dict[k] - then_dict[k])
		if diff == 0: continue
		return "%s %s%s %s" % [diff, k, "s" if diff != 1 else "", tense]

	return TENSE_NOW


#endregion
#region Instance

signal modified

@export var time_created : int
@export var time_modified : int

var save_path : String
func generate_save_path(folder := get_folder(), ext := FILE_EXT) -> String:
	var result := ""
	while true:
		result = "%s%s%s" % [folder, randi(), ext]
		if not FileAccess.file_exists(result): break
	return result
func get_folder() -> String:
	return "user://"


var save_name : String :
	get: return save_path.substr(save_path.rfind("/") + 1)

var save_dir : String :
	get: return get_parent_folder(1)

var save_dir_slash : String :
	get: return save_dir.path_join("")


var last_modified_short_blurb : String :
	get: return JsonResource.datetime_relative_blurb(time_modified)

var time_tooltip : String :
	get: return "Created %s\nLast modified %s" % [JsonResource.datetime_long_blurb(time_created), JsonResource.datetime_long_blurb(time_modified)]

func _init(__save_path__: String = generate_save_path()) -> void:
	save_path = __save_path__
	time_created = MincuzUtils.NOW
	time_modified = time_created
	if FileAccess.file_exists(save_path):
		load_from_file()
	else:
		save_to_file()


func commit_changes() -> void:
	time_modified = MincuzUtils.NOW
	save_to_file()
	modified.emit()


func load_from_file(path: String = save_path) -> void:
	save_path = path
	var file := FileAccess.open(path, FileAccess.READ)
	self.import_json(JSON.parse_string(file.get_as_text()))
func import_json(json: Dictionary) -> void:
	self.time_created = json[K_TIME_CREATED]
	self.time_modified = json[K_TIME_MODIFIED]
	print("import: ", json)
	print("time_created: ", self.time_created)
	_import_json(json)
func _import_json(json: Dictionary) -> void: pass


func save_to_file(path: String = save_path) -> void:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(self.export_json()))
func export_json() -> Dictionary:
	var result := {
		K_TIME_CREATED: time_created,
		K_TIME_MODIFIED: time_modified,
	}
	_export_json(result)
	return result
func _export_json(json: Dictionary) -> void: pass


func get_parent_folder(levels: int = 1, path: String = save_path) -> String:
	if path.is_empty(): return String()
	if levels <= 0: return path
	return get_parent_folder(levels - 1, path.substr(0, path.rfind("/")))

#endregion

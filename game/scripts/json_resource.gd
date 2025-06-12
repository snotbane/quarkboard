class_name JsonResource extends Resource

const FILE_EXT := ".json"

var existing_path : String

func get_save_path(folder := "user://", ext := FILE_EXT) -> String:
	if existing_path: return existing_path
	var result := ""
	while true:
		result = "%s%s%s" % [folder, randi(), ext]
		if not FileAccess.file_exists(result): break
	return result

func _init() -> void: pass

func save_file(path: String = existing_path) -> void:
	existing_path = path
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(self.export_json()))
func export_json() -> Dictionary:
	var result := {}
	_export_json(result)
	return result
func _export_json(json: Dictionary) -> void: pass


func load_file(path: String = existing_path) -> void:
	existing_path = path
	var file := FileAccess.open(path, FileAccess.READ)
	self.import_json(JSON.parse_string(file.get_as_text()))
func import_json(json: Dictionary) -> void: _import_json(json)
func _import_json(json: Dictionary) -> void: pass


# static func new_from_json(json: Dictionary) -> JsonResource:
# 	var result := JsonResource.new()
# 	result.import_json(json)
# 	return result

# static func new_from_load(path: String, template := JsonResource.new()) -> JsonResource:
# 	template.load_file(path)
# 	return template

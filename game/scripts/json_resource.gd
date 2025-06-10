class_name JsonResource extends Resource

func _init() -> void: pass

func save_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(self.export_json()))
func export_json() -> Dictionary:
	var result := {}
	_export_json(result)
	return result
func _export_json(json: Dictionary) -> void: pass


func load_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	self.import_json(JSON.parse_string(file.get_as_text()))
func import_json(json: Dictionary) -> void: _import_json(json)
func _import_json(json: Dictionary) -> void: pass


static func new_from_json(json: Dictionary) -> JsonResource:
	var result := JsonResource.new()
	result.import_json(json)
	return result
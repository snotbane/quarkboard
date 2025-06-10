class_name Tag extends JsonResource

signal name_changed(__name: String)
signal status_changed(__status: Status)

const K_NAME := &"name"
const K_STATUS := &"status"

static var REGISTRY : Array[Tag]

enum Status {
	NORMAL,
	ARCHIVED,
	REMOVED
}

var _name : String
@export var name : String :
	get: return _name
	set(value):
		if _name == value: return
		_name = value
		name_changed.emit(_name)
var _status : Status
@export var status : Status :
	get: return _status
	set(value):
		if _status == value: return
		_status = value
		status_changed.emit(_status)

func _init() -> void:
	REGISTRY.push_back(self)


func _export_json(json: Dictionary) -> void:
	json.merge({
		K_NAME: self.name,
		K_STATUS: self.status,
	})


func _import_json(json: Dictionary) -> void:
	self.name = json[K_NAME]
	self.status = json[K_STATUS]


static func new_or_get(__name: String) -> Tag:
	var existing := find_tag(__name)
	if existing: return existing
	var result := Tag.new()
	result.name = __name
	return result


static func find_tag(__name: String) -> Tag:
	for tag in REGISTRY: if tag.name == __name: return tag
	return null



func to_json() -> Variant:
	return self.name

static func new_from_json(json) -> Tag:
	var result := Tag.new()
	result.name = json[K_NAME]
	return result



func change_name(new_name: String, scene_tree: SceneTree) -> void:
	scene_tree.call_group(self.name, &"on_tag_name_changed", new_name)
	self.name = new_name

func change_status(new_status: Status, scene_tree: SceneTree) -> void:
	scene_tree.call_group(self.name, &"on_tag_status_changed", new_status)
	self.status = new_status

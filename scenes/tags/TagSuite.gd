class_name TagSuite extends Resource

var store_as_refs: bool
var list: Array[Tag]

func _init(__store_as_refs__: bool = true) -> void:
	store_as_refs = __store_as_refs__

func _serialize_custom() -> Variant:
	if store_as_refs:
		var result := PackedStringArray()
		result.resize(list.size())
		for i in result.size():
			result[i] = list[i].name
		return result

	else:
		return Serialization.serialize(list)

func _deserialize_custom(json: Array) -> void:
	list.resize(json.size())

	if store_as_refs:
		for i in json.size():
			list[i] = Tag.new(json[i])

	else:
		for i in json.size():
			list[i] = Serialization.deserialize(json[i])

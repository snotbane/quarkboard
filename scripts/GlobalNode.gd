
class_name GlobalNode extends Node

static var registry : Dictionary[StringName, Node]

static func get_global_node(node_name: StringName) -> Node:
	return registry.get(node_name)

func _enter_tree() -> void:
	var parent := get_parent()
	assert(not registry.has(parent.name), "Global node '%s' already exists." % parent.name)

	registry[parent.name] = parent

func _exit_tree() -> void:
	registry.erase(get_parent().name)

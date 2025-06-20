class_name EntryInstance extends Node

var _entry : Entry
var entry : Entry :
	get: return _entry
	set(value):
		if _entry == value: return

		if _entry:
			_entry.modified.disconnect(_on_entry_modified)

		_entry = value
		_on_set_entry.call_deferred()

		if _entry:
			_entry.modified.connect(_on_entry_modified)

func set_entry(value: Entry) -> void: entry = value
func _on_set_entry() -> void: pass


func _on_entry_modified() -> void: pass


func _ready() -> void:
	_on_set_entry.call_deferred()

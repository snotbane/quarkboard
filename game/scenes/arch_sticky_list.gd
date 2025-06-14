extends StickyContainer

@export var arch_editor : ArchEditor

var current_entry : Entry :
	get: return arch_editor.entry
	set(value):
		if current_entry == value: return

		if current_entry:
			current_sticky.deselect()
			current_entry.modified.disconnect(current_sticky._on_set_entry)


		arch_editor.entry = value
		for child in self.get_children():
			if child is not ArchSticky: continue
			if child.entry == current_entry: _current_sticky = child; break

		if current_entry:
			current_sticky.select()
			current_entry.modified.connect(current_sticky._on_set_entry)

func set_current_entry(new_entry: Entry = null) -> void:
	current_entry = new_entry

var _current_sticky : ArchSticky
var current_sticky : ArchSticky :
	get: return _current_sticky
	set(value): current_entry = value.entry


func create_new_sticky(entry := Entry.new()) -> Node:
	var result : ArchSticky = super.create_new_sticky(entry)
	result.clicked.connect(set_current_entry)
	set_current_entry.call_deferred(result.entry)
	return result


func _ready() -> void:
	super._ready()

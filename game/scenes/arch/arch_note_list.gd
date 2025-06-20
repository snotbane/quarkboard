extends NoteList

# @export var arch_editor : ArchEditor

# var current_note : Note :
# 	get: return arch_editor.note
# 	set(value):
# 		if current_note == value: return

# 		if current_note:
# 			current_sticky.deselect()
# 			current_note.modified.disconnect(current_sticky._on_set_note)


# 		arch_editor.note = value
# 		for child in self.get_children():
# 			if child is not ArchSticky: continue
# 			if child.note == current_note: _current_sticky = child; break

# 		if current_note:
# 			current_sticky.select()
# 			current_note.modified.connect(current_sticky._on_set_note)

# func set_current_note(new_note: Note = null) -> void:
# 	current_note = new_note

# var _current_sticky : ArchSticky
# var current_sticky : ArchSticky :
# 	get: return _current_sticky
# 	set(value): current_note = value.note


# func create_new_sticky(note := Note.new()) -> Node:
# 	var result : ArchSticky = super.create_new_sticky(note)
# 	result.clicked.connect(set_current_note)
# 	set_current_note.call_deferred(result.note)
# 	return result


# func _ready() -> void:
# 	super._ready()

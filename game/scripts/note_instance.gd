class_name NoteInstance extends Node

var _note : Note
var note : Note :
	get: return _note
	set(value):
		if _note == value: return

		if _note:
			_note.modified.disconnect(_on_note_modified)

		_note = value
		_on_set_note.call_deferred()

		if _note:
			_note.modified.connect(_on_note_modified)

func set_note(value: Note) -> void: note = value
func _on_set_note() -> void: pass


func _on_note_modified() -> void: pass


func _ready() -> void:
	_on_set_note.call_deferred()

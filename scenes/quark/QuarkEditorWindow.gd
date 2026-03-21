
extends Window

var quark : Quark :
	get: return get_child(0).quark


func refresh_title() -> void:
	title = quark.title_text


func _on_close_requested() -> void:
	queue_free()


extends TagList


func _tag_removed(tag: String) -> void:
	## TODO: confirm
	var affect_quarks := true

	socket.resource.remove_tag_globally(tag, affect_quarks)

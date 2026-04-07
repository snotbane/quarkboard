
extends TagList


func _tag_removed(tag: String) -> void:
	## TODO: confirm

	socket.resource.remove_tag_globally(tag)

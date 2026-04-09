
extends TagList


func _tag_removed(tag: Tag) -> void:
	## TODO: confirm

	socket.resource.remove_tag_globally(tag)

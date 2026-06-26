@abstract
class_name JsonResourceQB
extends JsonResource


enum {
	## The element is not shown.
	HIDDEN,

	## The element occupies the main [Control] within its parent.
	OCCUPY,

	## The element exists within its own separate window.
	POPOUT,
}

@export_storage var exist_state: int = HIDDEN


var occupied: bool:
	get: return exist_state == 1
	set(value):
		exist_state = 1 if value else 0


var popouted: bool:
	get: return exist_state == 2
	set(value):
		exist_state = 2 if value else 0


const TAG_FLAGGED := "_flagged"
var flagged: bool:
	get: return has_tag_by_name(TAG_FLAGGED)
	set(value):
		if flagged == value: return
		if value:
			create_tag_by_name(TAG_FLAGGED)
		else:
			remove_tag_by_name(TAG_FLAGGED)


const TAG_ARCHIVED := "_archived"
var archived: bool:
	get: return has_tag_by_name(TAG_ARCHIVED)
	set(value):
		if flagged == value: return
		if value:
			create_tag_by_name(TAG_ARCHIVED)
		else:
			remove_tag_by_name(TAG_ARCHIVED)


const TAG_RECYCLED := "_recycled"
var recycled: bool:
	get: return has_tag_by_name(TAG_RECYCLED)
	set(value):
		if flagged == value: return
		if value:
			create_tag_by_name(TAG_RECYCLED)
		else:
			remove_tag_by_name(TAG_RECYCLED)

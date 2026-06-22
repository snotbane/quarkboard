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

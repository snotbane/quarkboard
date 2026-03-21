
@tool extends TabContainer

func _ready() -> void:
	child_order_changed.connect(_child_order_changed)


func _child_order_changed() -> void:
	tabs_visible = get_tab_count() > 1

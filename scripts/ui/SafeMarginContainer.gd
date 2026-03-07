@tool class_name SafeMarginContainer extends MarginContainer

@export var add_margin_left : int = 0
@export var add_margin_top : int = 0
@export var add_margin_right : int = 0
@export var add_margin_bottom : int = 0

func _ready() -> void:
	refresh()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_SIZE_CHANGED, NOTIFICATION_WM_DPI_CHANGE, NOTIFICATION_RESIZED:
			refresh()

func refresh() -> void:
	var left_top : Vector2i
	var right_bottom : Vector2i

	if OS.has_feature("mobile"):
		var safe_margins := DisplayServer.get_display_safe_area()
		var screen_size := DisplayServer.screen_get_size()
		left_top = safe_margins.position
		right_bottom = screen_size - safe_margins.end
	else:
		left_top = Vector2i.ZERO
		right_bottom = Vector2i.ZERO

	self.add_theme_constant_override(&"margin_left", left_top.x + add_margin_left)
	self.add_theme_constant_override(&"margin_top", left_top.y + add_margin_top)
	self.add_theme_constant_override(&"margin_right", right_bottom.x + add_margin_right)
	self.add_theme_constant_override(&"margin_bottom", right_bottom.y + add_margin_bottom)

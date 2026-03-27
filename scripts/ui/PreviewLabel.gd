
class_name PreviewLabel extends RichTextLabel

@export var max_height : float = 350.0

var _shadow_label : RichTextLabel
var _full_text : String

func _ready() -> void:
	_shadow_label = self.duplicate(DUPLICATE_DEFAULT & ~DUPLICATE_SCRIPTS)
	_shadow_label.set_anchors_preset(PRESET_TOP_WIDE)
	_shadow_label.fit_content = true
	_shadow_label.scroll_active = false
	_shadow_label.visible = false
	add_child(_shadow_label)




func set_content(content: String) -> void:
	_full_text = content
	# self.text = content
	_shadow_label.text = content
	await get_tree().process_frame
	_apply_constraints()

func _apply_constraints() -> void:
	if _shadow_label.get_content_height() <= max_height:
		self.fit_content = true
		self.text = _full_text
		return

	# Lock panel height and hand off to the hidden measurer
	self.custom_minimum_size.y = max_height
	self.fit_content = false

	# _shadow_label.fit_content = true
	_shadow_label.size.x = self.size.x
	_shadow_label.custom_minimum_size.x = self.size.x

	var lo := 0
	var hi := _full_text.length()

	while lo < hi - 1:
		var mid := (lo + hi) / 2
		_shadow_label.text = _full_text.left(mid) + "..."
		await get_tree().process_frame          # invisible, so no flicker
		if _shadow_label.get_content_height() <= max_height:
			lo = mid
		else:
			hi = mid

	self.text = _full_text.left(lo) + "..."  # set exactly once
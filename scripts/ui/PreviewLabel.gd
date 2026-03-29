
class_name PreviewLabel extends RichTextLabel

const ELLIPSIS_TEXT := " ..."

static var REGEX_PATTERN_PREVIEW_STRIP_FRONT := RegEx.create_from_string(r"^\s*")
static var REGEX_PATTERN_PREVIEW_STRIP_BACK := RegEx.create_from_string(r"\s*$")


@export var max_height : float = 350.0

var _shadow_label : RichTextLabel
var _full_text : String
var _custom_minimum_size_default : Vector2

func _ready() -> void:
	_custom_minimum_size_default = _custom_minimum_size_default

	_shadow_label = self.duplicate(DUPLICATE_DEFAULT & ~DUPLICATE_SCRIPTS)
	_shadow_label.set_anchors_preset(PRESET_TOP_WIDE)
	_shadow_label.fit_content = true
	_shadow_label.scroll_active = false
	_shadow_label.visible = false
	_shadow_label.threaded = false
	# _shadow_label.self_modulate = Color(1, 0, 0, 0.5)
	add_child(_shadow_label)

	visibility_changed.connect(refresh)


func set_content(content: String) -> void:
	_full_text = REGEX_PATTERN_PREVIEW_STRIP_FRONT.sub(content, "")
	_shadow_label.text = _full_text

	await get_tree().process_frame

	_apply_constraints()

func refresh() -> void:
	set_content(_full_text)

var _last_application : int

func _apply_constraints() -> void:
	if _shadow_label.get_content_height() <= max_height:
		self.fit_content = true
		self.custom_minimum_size.y = _custom_minimum_size_default.y
		self.text = REGEX_PATTERN_PREVIEW_STRIP_BACK.sub(_shadow_label.text, "")
		return

	self.fit_content = false
	self.custom_minimum_size.y = max_height

	# _shadow_label.fit_content = true
	# _shadow_label.size.x = self.size.x
	# _shadow_label.custom_minimum_size.x = self.size.x

	_last_application = Time.get_ticks_msec()
	var _this_application := _last_application

	var lo := 0
	var hi := _full_text.length()

	while lo < hi - 1:
		if _this_application != _last_application: return

		var mid := (lo + hi) / 2
		_shadow_label.text = _full_text.left(mid) + ELLIPSIS_TEXT

		await get_tree().process_frame

		# print("_shadow_label.text : %s" % [ _shadow_label.text ])
		# print("_shadow_label.get_content_height() : %s" % [ _shadow_label.get_content_height() ])

		if _shadow_label.get_content_height() <= max_height:
			lo = mid
		else:
			hi = mid

	self.text = REGEX_PATTERN_PREVIEW_STRIP_BACK.sub(_full_text.left(lo), "") + ELLIPSIS_TEXT
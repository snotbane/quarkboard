class_name ErrorOverlay extends Control

static var global : ErrorOverlay

static var errors : PackedStringArray

static func global_push(message: String) -> void:
	if ErrorOverlay.global:
		ErrorOverlay.global.push(message)
	else:
		errors.push_back(message)


func _ready() -> void:
	if ErrorOverlay.global == null:
		ErrorOverlay.global = self

		if not errors: return

		self.push(errors[0])
		errors.remove_at(0)


func push(message: String) -> void:
	$dialog.dialog_text = message
	$dialog.show()


func _on_dialog_visibility_changed() -> void:
	visible = $dialog.visible

	if visible: return
	if ErrorOverlay.global != self: return
	if not errors: return

	self.push(errors[0])
	errors.remove_at(0)

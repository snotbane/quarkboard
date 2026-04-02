## A popup that appears within its parent's [member Control.get_global_rect()]. Use [member show] and [member hide] as you normally would with a [Control].
@tool class_name ControlPopup extends PopupPanel

## If enabled, the popup will act as if it is a direct [Control] child of the parent and follow its position and size as it moves.
## Otherwise, it will popup once and then not move again.
@export var as_child : bool = true

## Optional button that will control and be controlled by this popup.
@export var button : BaseButton


func _ready() -> void:
	if button:
		button.toggle_mode = true
		button.toggled.connect(set_visible)

	visibility_changed.connect(_visibility_changed)
	popup_hide.connect(_popup_hide)


func _process(delta: float) -> void:
	if not as_child: return

	position = get_parent().global_position
	size = get_parent().size

func _visibility_changed() -> void:
	if visible:
		popup(get_parent().get_global_rect())


func _popup_hide() -> void:
	if button:
		button.button_pressed = false

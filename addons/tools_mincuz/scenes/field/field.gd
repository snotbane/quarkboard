@tool class_name Field extends PanelContainer

const CONFIG_PATH := "user://prefs.cfg"
static var CONFIG := ConfigFile.new()

static func _static_init() -> void:
	var err := CONFIG.load(CONFIG_PATH)
	if err != OK: clear_all_config()


static func clear_all_config() -> void:
	CONFIG = ConfigFile.new()
	CONFIG.save(CONFIG_PATH)


static func get_global(section: StringName, key: StringName, default: Variant = null) -> Variant:
	return CONFIG.get_value(section, key, default)

signal value_changed(new_value: Variant, old_value: Variant)
signal value_changed_valid(new_value: Variant, old_value: Variant)

@export var store_in_user_config : bool
@export var user_config_section : StringName


@export var label_text : String :
	get:
		if not self.find_child("label"): return String()
		return $hbox/label.text
	set(value):
		if not self.find_child("label"): return
		# $hbox/label.custom_minimum_size.x = get_theme_constant("label_minimum_width")
		$hbox/label.text = value


var _ok_tooltip : String
var ok_tooltip : String :
	get: return _ok_tooltip
	set(value):
		if _ok_tooltip == value: return
		_ok_tooltip = value
		refresh_tooltip()
func refresh_tooltip() -> void:
	if Engine.is_editor_hint(): return
	self.tooltip_text = validation + (String() if is_valid else "\n") + ok_tooltip


var ok_stylebox : StyleBox
var error_stylebox : StyleBox

var _validation : String
var validation : String :
	get: return _validation
	set(value):
		if _validation == value: return
		_validation = value
		# self.add_theme_stylebox_override(&"panel", get_theme_stylebox(&"panel_ok") if is_valid else get_theme_stylebox(&"panel_error"))
		refresh_tooltip()
var is_valid : bool :
	get: return validation.is_empty()
func validate() -> void:
	validation = _get_validation()
func _get_validation() -> String: return String()


## Opens the config file using [OS.shell_open].
@export_tool_button("Show Config File") var __open_config__ := func() -> void:
	if not FileAccess.file_exists(ProjectSettings.globalize_path(CONFIG_PATH)): clear_all_config()
	OS.shell_open(ProjectSettings.globalize_path(CONFIG_PATH))

## Loads this value from the config file.
@export_tool_button("Load") var __load_from_config__ := load_from_config

## Sets this value in the config file.
@export_tool_button("Save") var __save_to_config__ := save_to_config

## Clears this value from the user config file.
@export_tool_button("Clear") var __clear_all_config__ := clear_all_config

var _previous_value : Variant
var _previous_value_valid : Variant
var field_value : Variant :
	get: return get(&"_field_value")
	set(value):
		if field_value == value: return
		set(&"_field_value", value)
		receive_internal_value_change()
func set_field_value(value: Variant) -> void:
	field_value = value

var field_value_as_cli_argument : String :
	get:
		if field_value is float and fmod(field_value, 1.0) == 0.0:
			return str(int(field_value))
		else:
			return str(field_value)

func _ready() -> void:
	_ok_tooltip = tooltip_text
	_previous_value = field_value
	_previous_value_valid = field_value

	# print(get_theme_constant(&"label_minimum_width"))
	# $hbox/label.custom_minimum_size.x = get_theme_constant(&"label_minimum_width")

	if not Engine.is_editor_hint(): load_from_config()

	validate()


func receive_internal_value_change() -> void:
	if field_value == _previous_value: return

	validate()
	save_to_config()

	_value_changed(field_value, _previous_value)
	value_changed.emit(field_value, _previous_value)
	_previous_value = field_value

	if not is_valid: return

	_value_changed_valid(field_value, _previous_value_valid)
	value_changed_valid.emit(field_value, _previous_value_valid)
	_previous_value_valid = field_value

func _value_changed(new_value: Variant, old_value: Variant) -> void: pass
func _value_changed_valid(new_value: Variant, old_value: Variant) -> void: pass


func load_from_config() -> void:
	if CONFIG.has_section_key(user_config_section, self.name):
		field_value = CONFIG.get_value(user_config_section, self.name)
	elif store_in_user_config and not Engine.is_editor_hint():
		save_to_config()


func save_to_config() -> void:
	CONFIG.set_value(user_config_section, self.name, self.field_value)
	CONFIG.save(CONFIG_PATH)


func clear_in_config() -> void:
	if not CONFIG.has_section_key(user_config_section, self.name): return
	CONFIG.erase_section_key(user_config_section, self.name)
	CONFIG.save(CONFIG_PATH)

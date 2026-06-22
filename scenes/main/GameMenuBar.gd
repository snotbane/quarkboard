extends AuxiliaryMenuBar

func _create_data() -> Array[Dictionary]:
	return [
		{
			"title": "File",
			"items": [
				{
					"event": (func() -> void:
						print("Creating new quark!")
						),
					"id": 0,
					"input": (func() -> InputEventKey:
						var result := InputEventKey.new()
						result.keycode = KEY_N
						result.command_or_control_autoremap = true
						return result
						),
					"title": "New Note",
				},
				{
					"title": "New Board",
					"event": (func() -> void:
						print("Creating new board!")
						),
					"id": 1,
					"input": (func() -> InputEventKey:
						var result := InputEventKey.new()
						result.keycode = KEY_N
						result.command_or_control_autoremap = true
						result.shift_pressed = true
						return result
						),
				},
			]
		},
		{
			"title": "Edit",
			"items": [
				{
					"event": (func() -> void:
						print("Open Preferences!")
						),
					"id": 0,
					"input": (func() -> InputEventKey:
						var result := InputEventKey.new()
						result.keycode = KEY_COMMA
						result.command_or_control_autoremap = true
						return result
						),
					"macos_id": 0,
					"macos_slot": MACOS_APPLE,
					"title": "Preferences",
				},
				{
					"event": (func() -> void:
						Game.inst.toggle_profiles_manager_window()
						),
					"id": 1,
					"input": (func() -> InputEventKey:
						var result := InputEventKey.new()
						result.keycode = KEY_1
						result.command_or_control_autoremap = true
						return result
						),
					"title": "Profiles...",
				}
			],
		},
	]

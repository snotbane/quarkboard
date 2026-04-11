
class_name UserPalette extends Resource

enum {
	SYSTEM,
	RED,
	ORANGE,
	YELLOW,
	GREEN,
	TEAL,
	BLUE,
	PURPLE,
	GRAY,
}

static var GLOBAL_RESOURCES : Dictionary[int, UserPalette] = {
	SYSTEM:		load("uid://cjmil5bpfo0to"),
	RED:		load("uid://c1ymxhiogju0j"),
	ORANGE:		load("uid://c2ui640l0ehn3"),
	YELLOW:		load("uid://brkn0g4xqwxpl"),
	GREEN:		load("uid://djvx5o4i7iheq"),
	TEAL:		load("uid://c0mfcmo4yunvs"),
	BLUE:		load("uid://b3mhvg0qb4k8u"),
	PURPLE:		load("uid://bfkfjmd7rupn2"),
	GRAY:		load("uid://dsm6wfiw5s3mf"),
}

static func get_palette(palette: int) -> UserPalette:
	return GLOBAL_RESOURCES[palette]


@export var normal_color : Color

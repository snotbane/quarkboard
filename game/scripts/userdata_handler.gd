class_name Master extends Node

const PATH := "user://userdata.json"

static var inst : Master

# static var userdata : Userdata

# func _ready() -> void:
# 	Master.inst = self

# 	userdata = Userdata.new()
# 	if FileAccess.file_exists(PATH): load_json()


# func _notification(what: int) -> void:
# 	match what:
# 		NOTIFICATION_WM_CLOSE_REQUEST:
# 			save_json()


class_name MincuzUtils


static var NOW : int :
	get: return floori(Time.get_unix_time_from_system())

static func get_paths_in_folder(root := "res://", include := RegEx.create_from_string(".*")) -> PackedStringArray:
	var dir := DirAccess.open(root)
	if not dir: return []

	var result : PackedStringArray = []

	if include.search(root):
		result.push_back(root)

	dir.list_dir_begin()
	var file : String = dir.get_next()
	while file:
		var next := root.path_join(file)
		if include.search(file):
			result.push_back(next)
		if dir.current_is_dir():
			result.append_array(get_paths_in_folder(next, include))
		file = dir.get_next()
	return result

# func move_folder_recursive(from: String, to: String) -> void:
# 	var dir := DirAccess.open(from)
# 	if dir == null:
# 		push_error("Failed to open source folder: " + from)
# 		return

# 	if not DirAccess.dir_exists_absolute(to):
# 		DirAccess.make_dir_recursive_absolute(to)

# 	dir.list_dir_begin()
# 	var file_name = dir.get_next()
# 	while file_name != "":
# 		if file_name == "." or file_name == "..":
# 			file_name = dir.get_next()
# 			continue

# 		var src_file_path = from + "/" + file_name
# 		var dest_file_path = to + "/" + file_name

# 		if dir.current_is_dir():
# 			move_folder_recursive(src_file_path, dest_file_path)
# 			DirAccess.remove_absolute(src_file_path)  # remove empty folder afterward
# 		else:
# 			FileAccess.copy_absolute(src_file_path, dest_file_path)
# 			FileAccess.remove_absolute(src_file_path)

# 		file_name = dir.get_next()

# 	dir.list_dir_end()
# 	DirAccess.remove_absolute(from)  # remove the now-empty source folder

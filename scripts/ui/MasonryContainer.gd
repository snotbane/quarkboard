## MasonryContainer.gd
## A custom Container that arranges children in a masonry ("Pinterest-style") layout.
##
## In VERTICAL mode, children are sorted into columns. Each new child
## is placed at the bottom of the shortest column, so items pack tightly with
## no wasted vertical space regardless of varying child heights.
##
## In HORIZONTAL mode, children are sorted into rows. Each new child is
## placed at the right end of the shortest row, packing tightly regardless of
## varying child widths.
##
## Usage notes:
## - Children should have a meaningful minimum size (via custom_minimum_size,
##   or by being sized controls like Labels with wrapping). The container uses
##   get_combined_minimum_size() to determine each child's natural dimensions.
## - Children whose height depends on their width (e.g. wrapped Labels) should
##   have custom_minimum_size.y set explicitly, since Godot doesn't reflow text
##   at a specific width during the sort pass.
## - Set size_flags_horizontal = SIZE_EXPAND_FILL on this container so it fills
##   its parent and the column widths are computed correctly.

@tool class_name MasonryContainer extends Container


## Returns the index of the smallest value in a PackedFloat32Array.
static func float32_array_find_min(arr: PackedFloat32Array) -> int:
	var best_idx := 0
	var best_val := arr[0]
	for i in arr.size():
		if arr[i] < best_val:
			best_val = arr[i]
			best_idx = i
	return best_idx


static func float32_array_max(array: PackedFloat32Array) -> float:
	if array.is_empty(): return 0.0

	var result := -INF
	for i in array.size():
		if array[i] > result:
			result = array[i]
	return result



enum Orientation {
	VERTICAL,   ## N columns; shortest column receives each next child.
	HORIZONTAL, ## N rows;    shortest row    receives each next child.
}


## Whether to lay children out in columns or rows.
@export var orientation: MasonryContainer.Orientation = MasonryContainer.Orientation.VERTICAL:
	set(value):
		orientation = value
		queue_sort()

## Number of rows or columns, depending on [member orientation].
@export_range(0, 64) var lanes_max: int = 0:
	set(value):
		lanes_max = maxi(0, value)
		queue_sort()


@export var lane_size_min : float = 100.0 :
	set(value):
		lane_size_min = maxf(1.0, value)
		queue_sort()

var lanes : int = 1

## Horizontal gap between children (pixels).
@export_range(0, 128) var h_separation: int = 4:
	set(value):
		h_separation = value
		queue_sort()

## Vertical gap between children (pixels).
@export_range(0, 128) var v_separation: int = 4:
	set(value):
		v_separation = value
		queue_sort()


# ---------------------------------------------------------------------------
# Container overrides
# ---------------------------------------------------------------------------

func _ready() -> void:
	get_window().size_changed.connect(queue_sort)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			_perform_layout()
		NOTIFICATION_THEME_CHANGED:
			queue_sort()


func _get_minimum_size() -> Vector2:
	var children := _get_visible_children()
	if children.is_empty():
		return Vector2.ZERO

	return (
		_minimum_size_vertical(children)
		if orientation == MasonryContainer.Orientation.VERTICAL
		else _minimum_size_horizontal(children)
	)


# ---------------------------------------------------------------------------
# Layout
# ---------------------------------------------------------------------------


func _sort_children(a: Control, b: Control) -> bool:
	return false


func _perform_layout() -> void:
	var children := _get_visible_children()
	if children.is_empty():
		return

	children.sort_custom(_sort_children)

	if orientation == MasonryContainer.Orientation.VERTICAL:
		_layout_vertical(children)
	else:
		_layout_horizontal(children)

var target_size : Vector2 :
	get: return size

func _layout_vertical(children: Array[Control]) -> void:
	var avail_w    := size.x
	var col_count  := _compute_lanes(target_size.x)
	var col_w      := (avail_w - h_separation * (col_count - 1)) / float(col_count)
	lanes = col_count

	# Running Y offset (cursor) for each column.
	var cursors := PackedFloat32Array()
	cursors.resize(col_count)
	cursors.fill(0.0)

	for child in children:
		# Choose the column whose cursor is lowest (least filled).
		var best_col  := float32_array_find_min(cursors)
		var child_min := child.get_combined_minimum_size()

		# X position: left edge of this column.
		var x := best_col * (col_w + h_separation)
		# Y position: current bottom of this column.
		var y := cursors[best_col]
		# Width fills the column; height is the child's natural minimum height.
		var h := maxf(child_min.y, 0.0)

		fit_child_in_rect(child, Rect2(x, y, col_w, h))

		cursors[best_col] += h + v_separation

	# Resize self to the tallest column so ScrollContainers work correctly.
	var max_height := float32_array_max(cursors) - v_separation  # remove trailing separator
	if size.y != max_height:
		custom_minimum_size.y = maxf(max_height, 0.0)


func _layout_horizontal(children: Array[Control]) -> void:
	var avail_h   := size.y
	var row_count := _compute_lanes(target_size.y)
	var row_h     := (avail_h - v_separation * (row_count - 1)) / float(row_count)
	lanes = row_count

	# Running X offset (cursor) for each row.
	var cursors := PackedFloat32Array()
	cursors.resize(row_count)
	cursors.fill(0.0)

	for child in children:
		var best_row  := float32_array_find_min(cursors)
		var child_min := child.get_combined_minimum_size()

		var x := cursors[best_row]
		var y := best_row * (row_h + v_separation)
		var w := maxf(child_min.x, 0.0)

		fit_child_in_rect(child, Rect2(x, y, w, row_h))

		cursors[best_row] += w + h_separation

	# Resize self to the widest row.
	var max_width := float32_array_max(cursors) - h_separation
	if size.x != max_width:
		custom_minimum_size.x = maxf(max_width, 0.0)


# ---------------------------------------------------------------------------
# Minimum size helpers
# ---------------------------------------------------------------------------


func _minimum_size_vertical(children: Array[Control]) -> Vector2:
	var min_w := lane_size_min
	var col_count := _compute_lanes(target_size.x) if target_size.x > 0.0 else 1

	# The minimum column width is the widest child's minimum width.
	var max_child_w := 0.0
	for child in children:
		max_child_w = maxf(max_child_w, child.get_combined_minimum_size().x)

	# var min_w := max_child_w * col_count + h_separation * (col_count - 1)

	# Simulate the greedy placement to get a realistic minimum height.
	var cursors := PackedFloat32Array()
	cursors.resize(col_count)
	cursors.fill(0.0)
	for child in children:
		var best  := float32_array_find_min(cursors)
		var child_h := child.get_combined_minimum_size().y
		cursors[best] += child_h + v_separation
	var min_h := float32_array_max(cursors) - v_separation

	return Vector2(min_w, maxf(min_h, 0.0))


## Minimum size for a horizontal (row-based) layout.
func _minimum_size_horizontal(children: Array[Control]) -> Vector2:
	var min_h := lane_size_min
	var row_count := _compute_lanes(target_size.y) if target_size.y > 0.0 else 1

	var max_child_h := 0.0
	for child in children:
		max_child_h = maxf(max_child_h, child.get_combined_minimum_size().y)

	# var min_h := max_child_h * row_count + v_separation * (row_count - 1)

	var cursors := PackedFloat32Array()
	cursors.resize(row_count)
	cursors.fill(0.0)
	for child in children:
		var best  := float32_array_find_min(cursors)
		var child_w := child.get_combined_minimum_size().x
		cursors[best] += child_w + h_separation
	var min_w := float32_array_max(cursors) - h_separation

	return Vector2(maxf(min_w, 0.0), min_h)


# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------

func _compute_lanes(avail_w: float) -> int:
	var sep := h_separation if orientation == MasonryContainer.Orientation.HORIZONTAL else v_separation
	var count := int((avail_w + sep) / (lane_size_min + sep))
	count = maxi(1, count)
	if lanes_max > 0:
		count = mini(count, lanes_max)
	return count

## Returns all direct Control children that are visible and not set to
## ignore layout (CanvasItem.visible == true, Control.top_level == false).
func _get_visible_children() -> Array[Control]:
	var result: Array[Control] = []
	for child in get_children():
		if child is Control and child.visible and not child.top_level:
			result.append(child as Control)
	return result

extends Control

var board: Board:
	get: return $board.resource
	set(value):
		$board.resource = value

func populate(element: Board) -> void:
	if not is_node_ready():
		await ready

	board = element

	# show.call_deferred()

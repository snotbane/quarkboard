
class_name BoardView extends Control

var _board : Board
var board : Board :
	get: return _board
	set(value):
		if _board == value: return
		_board = value



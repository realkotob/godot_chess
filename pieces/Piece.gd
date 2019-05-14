extends Node2D

signal moved
signal died

var board_pos = Vector2()
var team
var valid_moves = []

func move(end):
	z_index = end.y * 2
	$MoveTween.interpolate_property(self, "position", position, end, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()
	yield($MoveTween, "tween_completed")
	emit_signal("moved")
	z_index = end.y

func die():
	queue_free()
	emit_signal("died", self)
	
func move_check(board):
	var moves = []
	var tile
	if is_in_group("pawns"):
		var y_move = 1
		var x_move = [-1, 1]
		if is_in_group("white"):
			y_move = -1
		if board_pos.x + y_move < len(board) and board_pos.x + y_move >= 0:
			tile = board[board_pos.x + y_move][board_pos.y]
			if tile.current_state == null:
				moves.append(tile)
			for move in x_move:
				if board_pos.y + move < len(board[board_pos.x + y_move]) and board_pos.y + move >= 0:
					tile = board[board_pos.x + y_move][board_pos.y + move]
					if !tile.current_state == null:
						if is_in_group("white"):
							if tile.current_state.is_in_group("black"):
								moves.append(tile)
						if is_in_group("black"):
							if tile.current_state.is_in_group("white"):
								moves.append(tile)
	return moves
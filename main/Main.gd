extends Node2D

var board_state
var active_tile = null
var active_piece = null
var valid_moves = []

func _ready():
	board_state = $Board.create_board()
	$WhitePlayer.generate_team(board_state)
	$BlackPlayer.generate_team(board_state)

func _on_Board_clicked_tile(tile):
	if active_tile == null:
		if !tile.current_state == null:
			valid_moves = tile.current_state.move_check(board_state)
			active_piece = tile.current_state
			active_tile = tile
			for move in valid_moves:
				print(move.grid_position)
	else:
		if tile in valid_moves:
			yield(active_piece.move(tile.tile_center), "completed")
			if !tile.current_state == null:
				tile.current_state.die()
			active_piece.board_pos = tile.grid_position
			active_tile.current_state = null
			tile.current_state = active_piece
		active_piece = null
		active_tile = null
		valid_moves = []
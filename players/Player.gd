extends Node

export (PackedScene) var Pawn
export (PackedScene) var Rook
export (PackedScene) var Knight
export (PackedScene) var Bishop
export (PackedScene) var Queen
export (PackedScene) var King
export var team = ""

func generate_team(board):
	var pawn_row = 1
	var royal_row = 0
	match team:
		"black":
			pawn_row = 1
			royal_row = 0
		"white":
			pawn_row = 6
			royal_row = 7
	for i in 8:
		var p = Pawn.instance()
		p.board_pos = Vector2(pawn_row, i)
		p.add_to_group("pawns")
		p.add_to_group(team)
		$Pieces.add_child(p)
		
	for piece in $Pieces.get_children():
		var tile = board[piece.board_pos.x][piece.board_pos.y]
		piece.move(tile.tile_center)
		tile.current_state = piece
		
func ai_move(board):
	var move_list = {}
	var moves = []
	for piece in $Pieces.get_children():
		moves = piece.move_check(board)
		if len(moves) > 0:
			move_list[piece] = moves

func team_move_check(board):
	for piece in $Pieces.get_children():
		piece.valid_moves = piece.move_check(board)
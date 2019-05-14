extends Node2D

var board_state
var playing = true

func _ready():
	randomize()
	board_state = $Board.create_board()
	$WhitePlayer.generate_team(board_state)
	$BlackPlayer.generate_team(board_state)
	start_game()
		
func human_turn():
	var active_piece
	var active_tile
	var clicked_tile
	var finished = false
	$WhitePlayer.team_move_check(board_state)
	while !finished:
		clicked_tile = yield($Board, "clicked_tile")
		if active_tile == null:
			if !clicked_tile.current_state == null:
				if clicked_tile.current_state.is_in_group("white"):
					active_tile = clicked_tile
					active_piece = clicked_tile.current_state
		else:
			if len(active_piece.valid_moves) > 0:
				if clicked_tile in active_piece.valid_moves:
					yield(active_piece.move(clicked_tile.tile_center), "completed")
					if !clicked_tile.current_state == null:
						if clicked_tile.current_state.is_in_group("black"):
							clicked_tile.current_state.die()
					active_piece.board_pos = clicked_tile.grid_position
					active_tile.current_state = null
					clicked_tile.current_state = active_piece
					finished = true
			active_piece = null
			active_tile = null
			
func ai_turn():
	print($BlackPlayer/Pieces.get_child_count())
	var active_pieces = []
	var active_piece
	var chosen_move
	$BlackPlayer.team_move_check(board_state)
	for piece in $BlackPlayer/Pieces.get_children():
		if piece.valid_moves.size() > 0:
			active_pieces.append(piece)
	active_piece = active_pieces[randi()%active_pieces.size()]
	chosen_move = active_piece.valid_moves[randi()%active_piece.valid_moves.size()]
	yield(active_piece.move(chosen_move.tile_center), "completed")
	if !chosen_move.current_state == null:
		if chosen_move.current_state.is_in_group("white"):
			chosen_move.current_state.die()
	board_state[active_piece.board_pos.x][active_piece.board_pos.y].current_state = null
	active_piece.board_pos = chosen_move.grid_position
	chosen_move.current_state = active_piece

func start_game():
	var playing = true
	while playing:
		yield(human_turn(), "completed")
		yield(ai_turn(), "completed")
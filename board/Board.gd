extends Node2D

export (PackedScene) var LightTile
export (PackedScene) var DarkTile

signal clicked_tile

func create_board():
	var board = []
	var tile_color = "dark"
	var starting_position = $BoardBackground.map_to_world(Vector2(1, 1))
	for y in 8:
		var row = []
		for x in 8:
			var t
			if tile_color == "dark":
				t = DarkTile.instance()
				tile_color = "light"
			else:
				t = LightTile.instance()
				tile_color = "dark"
			var pos = Vector2(starting_position.x + 32 * x, starting_position.y + 32 * y)
			var grid_pos = Vector2(y, x)
			t.position = pos
			t.grid_position = grid_pos
			t.tile_center = position + t.position + Vector2(16, 16)
			add_child(t)
			t.connect("clicked", self, "on_Tile_clicked")
			row.append(t)
		if tile_color == "dark":
			tile_color = "light"
		else:
			tile_color = "dark"
		board.append(row)
	return board

func on_Tile_clicked(tile):
	emit_signal("clicked_tile", tile)
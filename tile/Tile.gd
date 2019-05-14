extends Area2D

var grid_position = Vector2()
var tile_center
var current_state = null
signal clicked

func _on_Tile_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and  event.pressed:
		emit_signal("clicked", self)
		
func highlight():
	$Sprite.modulate = Color(0.5, 1, 0.5, 1)
	
func stop_highlight():
	$Sprite.modulate = Color(1, 1, 1, 1)
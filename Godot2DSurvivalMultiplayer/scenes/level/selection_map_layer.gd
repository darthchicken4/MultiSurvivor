extends TileMapLayer

@export var highlight_source_id: int = 1  # whatever source ID your highlight tile is
@export var highlight_coords: Vector2i = Vector2i(0, 0)  # atlas coords of highlight tile

var last_highlight: Vector2i = Vector2i(-9999, -9999)

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var tile_pos = local_to_map(to_local(mouse_pos))
	
	if tile_pos == last_highlight:
		return
	if get_viewport() == null:
		return
	if get_viewport().get_camera_2d() == null:
		return

	
	# Clear previous highlight
	erase_cell(last_highlight)
	
	# Draw new highlight
	
	if get_viewport().get_camera_2d().global_position.distance_to(mouse_pos) < 120:
		set_cell(tile_pos, highlight_source_id, highlight_coords)
	
	last_highlight = tile_pos
